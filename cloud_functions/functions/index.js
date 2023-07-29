const admin = require("firebase-admin");
const functions = require("firebase-functions");
const config = functions.config();
admin.initializeApp(config.firebase);
const fireStore = admin.firestore();
// algolia
const algoliasearch = require('algoliasearch');
const algoliaConfig = config.algolia;
const ALGOLIA_APP_ID = algoliaConfig.app_id;  // app_id
const ALGOLIA_ADMIN_KEY = algoliaConfig.admin_key;  // admin_key
const ALGOLIA_POSTS_INDEX_NAME = "posts";
const client = algoliasearch(ALGOLIA_APP_ID,ALGOLIA_ADMIN_KEY);
// AWS
const AWS = require('aws-sdk');
const aws_config = config.aws;
const AWS_ACCESS_KEY = aws_config.access_key;
const AWS_SECRET_ACCESS_KEY = aws_config.secret_access_key;
const AWS_REGION = "ap-southeast-1";  //大阪リージョンに変更？
// IAM設定
AWS.config.update({
    accessKeyId: AWS_ACCESS_KEY,
    secretAccessKey: AWS_SECRET_ACCESS_KEY,
    region: AWS_REGION,
});
// comprehendに渡す値を準備
const comprehend = new AWS.Comprehend({apiVersion: '2017-11-27'});
// sendgrid
const sgMail = require('@sendgrid/mail');
const SENDGRID_API_KEY = config.sendgrid.api_key;

const batchLimit = 500;
const plusOne = 1;
const minusOne = -1;

// cloud Functionはsecurity rulesを無視することができる


//  ---------------------------------------------------------------------------------
function mul100AndRoundingDown(num) {
    const mul100 = num * 100;  // ex) 0.9988を99.88にする
    const result = Math.floor(mul100);  //数字を丸める
    return result;
}
function sendMail(text, subject) {
    sgMail.setApiKey(SENDGRID_API_KEY);  //関数のたびにAPIをセットしなければならない
    const msg = {
        to: 'hiro.8181.58@ezweb.ne.jp',  //送り先
        from: 'hi130404@gmail.com',  //送り元
        subject: subject,  //主題
        text: text,  //内容
    };
    sgMail.send(msg).then((ref) => {
        console.log(ref);  // refを出力
    }).catch(e => {
        console.log(e);  // errorを出力
    });
}

function sendReport(data, contentType) {  // firestoreのdocumentSnapshotを受け取ったものをString型にしたもの
    const stringData = JSON.stringify(data);  // Dartでいう Map<String,dynamic> map.toString();
    const result = stringData.replace(/,/g, ",\n");  //文字列に変換されたデータの中で , を探し、 ,\n にしている
    sendMail(result, `${contentType}を報告`);
}

exports.onUserCreate = functions.firestore.document('users/{uid}').onCreate(
    async (snap,_) => {  // snapにはuserのdocumentSnapshotが入っている
        const newValue = snap.data();
        const ref = snap.ref;
        const text = newValue.userName;  //解析したい値
        const dDparams = {
            Text: text,
        };
        //主要な言語のcodeを取得  ("ja","en",etc...)
        let lCode = '';
        comprehend.detectDominantLanguage(
            dDparams,
            async (dDerr, dDdata) => {
                // dDerrにはdetectDominantLanguageで発生したエラーコード
                // dDdataにはdetectDominantLanguageで発生したdata
                if(dDerr) {
                    //もしエラーがあれば
                    console.log(dDerr);
                } else {
                    // dDdataは複数のLanguageCodeを返す  (ja 90%, en 10%)
                    lCode = dDdata.Languages[0]["LanguageCode"];  //一番確率の高いLanguageCode
                    if(lCode) {
                        // lCodeが空欄でなければ
                        const dSparams = {
                            LanguageCode: lCode,
                            Text: text,
                        };
                        comprehend.detectSentiment(
                            dSparams,
                            async (dSerr, dSdata) => {
                                if(dSerr) {
                                    console.log(dSerr);
                                } else {
                                    await ref.update({
                                        'userNameLanguageCode': lCode,
                                        'userNameNegativeScore': mul100AndRoundingDown(dSdata.SentimentScore.Negative),
                                        'userNamePositiveScore': mul100AndRoundingDown(dSdata.SentimentScore.Positive),
                                        'userNameSentiment': dSdata.Sentiment,
                                    });
                                }
                            }
                        );
                    }
                }
            }
        );
    }
);
//---------------------------------------------------------------------------------------------------------


//ユーザーを削除  -----------------------------------------------------------------------------------------
exports.onDeleteUserCreate = functions.firestore.document('deleteUsers/{uid}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const uid = snap.id;
        const myRef = fireStore.collection('users').doc(uid);

        //末端から順番に削除

        //自分が作成したreplyを削除
        const replies = await fireStore.collectionGroup('postCommentReplies').where('uid', '==', uid).get();
        let replyCount = 0;
        let replyBatch = fireStore.batch();
        for(const reply of replies.docs) {
            replyBatch.delete(reply.ref);
            replyCount++;
            if(replyCount == batchLimit) {
                await replyBatch.commit();
                replyBatch = fireStore.batch();
                replyCount = 0;
            }
        }
        if(replyCount > 0) {
            await replyBatch.commit();
        }
        
        //自分が作成したcommentを削除
        const comments = await fireStore.collectionGroup('postComments').where('uid', '==', uid).get();
        let commentCount = 0;
        let commentBatch = fireStore.batch();
        for(const comment of comments.docs) {
            commentBatch.delete(comment.ref);
            commentCount++;
            if(commentCount == batchLimit) {
                await commentBatch.commit();
                commentBatch = fireStore.batch();
                commentCount = 0;
            }
        }
        if(commentCount > 0) {
            await commentBatch.commit();
        }

        //自分が作成したPostを削除
        const posts = await myRef.collection('posts').get();
        let postCount = 0;
        let postBatch = fireStore.batch();
        for(const post of posts.docs) {
            postBatch.delete(post.ref);
            postCount++;
            if(postCount == batchLimit) {
                await postBatch.commit();
                postBatch = fireStore.batch();
                postCount = 0;
            }
        }
        if(postCount > 0) {
            await postBatch.commit();
        }

        //自分timelineを削除
        const timelines = await myRef.collection('timelines').get();
        let timelineCount = 0;
        let timelineBatch = fireStore.batch();
        for(const timeline of timelines.docs) {
            timelineBatch.delete(timeline.ref);
            timelineCount++;
            if(timelineCount == batchLimit) {
                await timelineBatch.commit();
                timelineBatch = fireStore.batch();
                timelineCount = 0;
            }
        }
        if(timelineCount > 0) {
            await timelineBatch.commit();
        }

        //自分tokenを削除
        const tokens = await myRef.collection('tokens').get();
        let tokenCount = 0;
        let tokenBatch = fireStore.batch();
        for(const token of tokens.docs) {
            tokenBatch.delete(token.ref);
            tokenCount++;
            if(tokenCount == batchLimit) {
                await tokenBatch.commit();
                tokenBatch = fireStore.batch();
                tokenCount = 0;
            }
        }
        if(tokenCount > 0) {
            await tokenBatch.commit();
        }

        await myRef.delete();  //一番最後
    }
);
//---------------------------------------------------------------------------------------------------------


//フォローしたらカウント  ---------------------------------------------------------------------------------
exports.onFollowerCreate = functions.firestore.document('users/{uid}/followers/{followerUid}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await fireStore.collection('users').doc(newValue.followedUid).update({
            'followerCount': admin.firestore.FieldValue.increment(plusOne),
        });
        await fireStore.collection('users').doc(newValue.followerUid).update({
            'followingCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);

exports.onFollowerDelete = functions.firestore.document('users/{uid}/followers/{followerUid}').onDelete(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await fireStore.collection('users').doc(newValue.followedUid).update({
            'followerCount': admin.firestore.FieldValue.increment(minusOne),
        });
        await fireStore.collection('users').doc(newValue.followerUid).update({
            'followingCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
//---------------------------------------------------------------------------------------------------------


//ユーザーをミュートしたらカウント  -----------------------------------------------------------------------
exports.onUserMutesCreate = functions.firestore.document('users/{uid}/userMutes/{activeUid}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.passiveUserRef.update({
            'muteCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);

exports.onUserMutesDelete = functions.firestore.document('users/{uid}/userMutes/{activeUid}').onDelete(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.passiveUserRef.update({
            'muteCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
//---------------------------------------------------------------------------------------------------------


//投稿にいいねされたらカウント  ---------------------------------------------------------------------------
exports.onPostLikeCreate = functions.firestore.document('users/{uid}/posts/{postId}/postLikes/{activeUid}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postRef.update({
            'likeCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);

exports.onPostLikeDelete = functions.firestore.document('users/{uid}/posts/{postId}/postLikes/{activeUid}').onDelete(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postRef.update({
            'likeCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
//---------------------------------------------------------------------------------------------------------


//投稿のレポートが作成されたらカウント  -------------------------------------------------------------------
exports.onPostReportCreate = functions.firestore.document('users/{uid}/posts/{postId}/postReports/{postReport}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postDocRef.update({
            'reportCount': admin.firestore.FieldValue.increment(plusOne),
        });
        sendReport(newValue, '投稿');
    }
);
//---------------------------------------------------------------------------------------------------------


//投稿のコメントにいいねされたらカウント  -----------------------------------------------------------------
exports.onPostCommentLikeCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{id}/postCommentLikes/{activeUid}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postCommentRef.update({
            'likeCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);

exports.onPostCommentLikeDelete = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{id}/postCommentLikes/{activeUid}').onDelete(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postCommentRef.update({
            'likeCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
//---------------------------------------------------------------------------------------------------------


//コメントのレポートが作成されたらカウント  ---------------------------------------------------------------
exports.onPostCommentReportCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{id}/postCommentReports/{reportId}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postCommentDocRef.update({
            'reportCount': admin.firestore.FieldValue.increment(plusOne),
        });
        sendReport(newValue, 'コメント');
    }
);
//---------------------------------------------------------------------------------------------------------


//投稿したらカウント  -------------------------------------------------------------------------------------
exports.onPostCommentCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{id}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        const ref = snap.ref;
        const text = newValue.comment;  //解析したい値
        const dDparams = {
            Text: text,
        };
        //主要な言語のcodeを取得  ("ja","en",etc...)
        let lCode = '';
        comprehend.detectDominantLanguage(
            dDparams,
            async (dDerr, dDdata) => {
                // dDerrにはdetectDominantLanguageで発生したエラーコード
                // dDdataにはdetectDominantLanguageで発生したdata
                if(dDerr) {
                    //もしエラーがあれば
                    console.log(dDerr);
                } else {
                    // dDdataは複数のLanguageCodeを返す  (ja 90%, en 10%)
                    lCode = dDdata.Languages[0]["LanguageCode"];  //一番確率の高いLanguageCode
                    if(lCode) {
                        // lCodeが空欄でなければ
                        const dSparams = {
                            LanguageCode: lCode,
                            Text: text,
                        };
                        comprehend.detectSentiment(
                            dSparams,
                            async (dSerr, dSdata) => {
                                if(dSerr) {
                                    console.log(dSerr);
                                } else {
                                    await ref.update({
                                        'commentLanguageCode': lCode,
                                        'commentNegativeScore': mul100AndRoundingDown(dSdata.SentimentScore.Negative),
                                        'commentPositiveScore': mul100AndRoundingDown(dSdata.SentimentScore.Positive),
                                        'commentSentiment': dSdata.Sentiment,
                                    });
                                }
                            }
                        );
                    }
                }
            }
        );
        await newValue.postRef.update({
            'commentCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);

exports.onPostCommentDelete = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{id}').onDelete(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postRef.update({
            'commentCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
//---------------------------------------------------------------------------------------------------------


//投稿をミュートしたらカウント  -----------------------------------------------------------------------
exports.onPostMuteCreate = functions.firestore.document('users/{uid}/posts/{postId}/postMutes/{activeUid}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postRef.update({
            'muteCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);

exports.onPostMuteDelete = functions.firestore.document('users/{uid}/posts/{postId}/postMutes/{activeUid}').onDelete(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postRef.update({
            'muteCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
//---------------------------------------------------------------------------------------------------------


//コメントをミュートしたらカウント  -----------------------------------------------------------------------
exports.onPostCommentMuteCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentMutes/{activeUid}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postCommentRef.update({
            'muteCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);

exports.onPostCommentMuteDelete = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentMutes/{activeUid}').onDelete(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postCommentRef.update({
            'muteCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
//---------------------------------------------------------------------------------------------------------


//コメントをミュートしたらカウント  -----------------------------------------------------------------------
exports.onPostCommentReplyMuteCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentReplies/{postCommentReplyId}/postCommentReplyMutes/{activeUid}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postCommentReplyRef.update({
            'muteCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);

exports.onPostCommentReplyMuteDelete = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentReplies/{postCommentReplyId}/postCommentReplyMutes/{activeUid}').onDelete(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postCommentReplyRef.update({
            'muteCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
//---------------------------------------------------------------------------------------------------------


//リプライにいいねされたらカウント  -----------------------------------------------------------------------
exports.onPostCommentReplyLikeCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentReplies/{postCommentReplyId}/postCommentReplyLikes/{activeUid}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postCommentReplyRef.update({
            'likeCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);

exports.onPostCommentReplyLikeDelete = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentReplies/{postCommentReplyId}/postCommentReplyLikes/{activeUid}').onDelete(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postCommentReplyRef.update({
            'likeCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
//---------------------------------------------------------------------------------------------------------


//リプライのレポートが作成されたらカウント  ---------------------------------------------------------------
exports.onPostCommentReplyReportCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentReplies/{postCommentReplyId}/postCommentReplyReports/{reportId}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postCommentReplyDocRef.update({
            'reportCount': admin.firestore.FieldValue.increment(plusOne),
        });
        sendReport(newValue, 'リプライ');
    }
);
//---------------------------------------------------------------------------------------------------------


//リプライされたらカウント  -------------------------------------------------------------------------------
exports.onPostCommentReplyCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentReplies/{postCommentReplyId}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        const ref = snap.ref;
        const text = newValue.reply;  //解析したい値
        const dDparams = {
            Text: text,
        };
        //主要な言語のcodeを取得  ("ja","en",etc...)
        let lCode = '';
        comprehend.detectDominantLanguage(
            dDparams,
            async (dDerr, dDdata) => {
                // dDerrにはdetectDominantLanguageで発生したエラーコード
                // dDdataにはdetectDominantLanguageで発生したdata
                if(dDerr) {
                    //もしエラーがあれば
                    console.log(dDerr);
                } else {
                    // dDdataは複数のLanguageCodeを返す  (ja 90%, en 10%)
                    lCode = dDdata.Languages[0]["LanguageCode"];  //一番確率の高いLanguageCode
                    if(lCode) {
                        // lCodeが空欄でなければ
                        const dSparams = {
                            LanguageCode: lCode,
                            Text: text,
                        };
                        comprehend.detectSentiment(
                            dSparams,
                            async (dSerr, dSdata) => {
                                if(dSerr) {
                                    console.log(dSerr);
                                } else {
                                    await ref.update({
                                        'replyLanguageCode': lCode,
                                        'replyNegativeScore': mul100AndRoundingDown(dSdata.SentimentScore.Negative),
                                        'replyPositiveScore': mul100AndRoundingDown(dSdata.SentimentScore.Positive),
                                        'replySentiment': dSdata.Sentiment,
                                    });
                                }
                            }
                        );
                    }
                }
            }
        );
        await newValue.postCommentRef.update({
            'postCommentReplyCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);

exports.onPostCommentReplyDelete = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentReplies/{postCommentReplyId}').onDelete(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        await newValue.postCommentRef.update({
            'postCommentReplyCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
//---------------------------------------------------------------------------------------------------------


//プロフィールの変更でユーザーが余計に変更できないように制限する  -----------------------------------------
exports.onUserUpdateLogCreate = functions.firestore.document('users/{uid}/userUpdateLogs/{userUpdateLogId}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();  // newValueにはUserUpdateLogの情報が入っている
        const userRef = newValue.userRef;
        const uid = newValue.uid;
        const userName = newValue.userName;
        const userImageURL = newValue.userImageURL;
        const searchToken = newValue.searchToken;
        const now = admin.firestore.Timestamp.now();
        const text = newValue.userName;  //解析したい値
        const dDparams = {
            Text: text,
        };
        //主要な言語のcodeを取得  ("ja","en",etc...)
        let lCode = '';
        comprehend.detectDominantLanguage(
            dDparams,
            async (dDerr, dDdata) => {
                // dDerrにはdetectDominantLanguageで発生したエラーコード
                // dDdataにはdetectDominantLanguageで発生したdata
                if(dDerr) {
                    //もしエラーがあれば
                    console.log(dDerr);
                } else {
                    // dDdataは複数のLanguageCodeを返す  (ja 90%, en 10%)
                    lCode = dDdata.Languages[0]["LanguageCode"];  //一番確率の高いLanguageCode
                    if(lCode) {
                        // lCodeが空欄でなければ
                        const dSparams = {
                            LanguageCode: lCode,
                            Text: text,
                        };
                        comprehend.detectSentiment(
                            dSparams,
                            async (dSerr, dSdata) => {
                                if(dSerr) {
                                    console.log(dSerr);
                                } else {
                                    await userRef.update({
                                        // textの解析とLog経由のupdateを兼ねている
                                        'searchToken': searchToken,
                                        'userName': userName,
                                        'userImageURL': userImageURL,
                                        'userNameLanguageCode': lCode,
                                        'userNameNegativeScore': mul100AndRoundingDown(dSdata.SentimentScore.Negative),
                                        'userNamePositiveScore': mul100AndRoundingDown(dSdata.SentimentScore.Positive),
                                        'userNameSentiment': dSdata.Sentiment,
                                        'updateAt': now,  // updateAtは改竄されないようにcloud functionsで制限する
                                    });
                                }
                            }
                        );
                    }
                }
            }
        );
        //複数の投稿をupdateするのでbatchが必要
        const postQshot = await fireStore.collection('users').doc(uid).collection('posts').get();  //全ての投稿を取得
        //一回のbatchにつき、500回までしか処理できないので500回で一度止めて更新する必要がある
        let postCount = 0;
        let postBatch = fireStore.batch();
        for(const post of postQshot.docs) { //Query documentSnapShotが一つずつ入っている
            postBatch.update(post.ref, {
                'userName': userName,
                'userImageURL': userImageURL,
                'updateAt': now,  // updateAtは改竄されないようにcloud functionsで制限する
            })
            postCount += 1;
            if(postCount == batchLimit) {
                // 500行ったらcommit
                await postBatch.commit();
                // batchを新しく取得
                postBatch = fireStore.batch();
                postCount = 0;
            }
        }
        if(postCount > 0) {
            await postBatch.commit();
        }

        // commentの処理
        // collectionGroupを使用し、fieldで制限する（uidとか）場合は除外が必要
        const commentQshot = await fireStore.collectionGroup('postComments').where('uid', '==', uid).get();
        let commentCount = 0;
        let commentBatch = fireStore.batch();
        for(const comment of commentQshot.docs) { //Query documentSnapShotが一つずつ入っている
            commentBatch.update(comment.ref, {
                'userName': userName,
                'userImageURL': userImageURL,
                'updateAt': now,  // updateAtは改竄されないようにcloud functionsで制限する
            })
            commentCount += 1;
            if(commentCount == batchLimit) {
                // 500行ったらcommit
                await commentBatch.commit();
                // batchを新しく取得
                commentBatch = fireStore.batch();
                commentCount = 0;
            }
        }
        if(commentCount > 0) {
            await commentBatch.commit();
        }

        //replyの処理
        const replyQshot = await fireStore.collectionGroup('postCommentReplies').where('uid', '==', uid).get();
        let replyCount = 0;
        let replyBatch = fireStore.batch();
        for(const reply of replyQshot.docs) { //Query documentSnapShotが一つずつ入っている
            replyBatch.update(reply.ref, {
                'userName': userName,
                'userImageURL': userImageURL,
                'updateAt': now,  // updateAtは改竄されないようにcloud functionsで制限する
            })
            replyCount += 1;
            if(replyCount == batchLimit) {
                // 500行ったらcommit
                await replyBatch.commit();
                // batchを新しく取得
                replyBatch = fireStore.batch();
                replyCount = 0;
            }
        }
        if(replyCount > 0) {
            await replyBatch.commit();
        }
    }
);
//---------------------------------------------------------------------------------------------------------


//  -------------------------------------------------------------------------------
exports.onPostCreate = functions.firestore.document('users/{uid}/posts/{postId}').onCreate(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        const ref = snap.ref;
        // detectSentiment
        const text = newValue.text;  //解析したい値
        const dDparams = {
            Text: text,
        };
        //主要な言語のcodeを取得  ("ja","en",etc...)
        let lCode = '';
        comprehend.detectDominantLanguage(
            dDparams,
            async (dDerr, dDdata) => {
                // dDerrにはdetectDominantLanguageで発生したエラーコード
                // dDdataにはdetectDominantLanguageで発生したdata
                if(dDerr) {
                    //もしエラーがあれば
                    console.log(dDerr);
                } else {
                    // dDdataは複数のLanguageCodeを返す  (ja 90%, en 10%)
                    lCode = dDdata.Languages[0]["LanguageCode"];  //一番確率の高いLanguageCode
                    if(lCode) {
                        // lCodeが空欄でなければ
                        const dSparams = {
                            LanguageCode: lCode,
                            Text: text,
                        };
                        comprehend.detectSentiment(
                            dSparams,
                            async (dSerr, dSdata) => {
                                if(dSerr) {
                                    console.log(dSerr);
                                } else {
                                    await ref.update({
                                        'textLanguageCode': lCode,
                                        'textNegativeScore': mul100AndRoundingDown(dSdata.SentimentScore.Negative),
                                        'textPositiveScore': mul100AndRoundingDown(dSdata.SentimentScore.Positive),
                                        'textSentiment': dSdata.Sentiment,
                                    });
                                }
                            }
                        );
                    }
                }
            }
        );
        // algolia
        newValue.objectID = snap.id;  // objectIDはalgolia専用のID
        const index = client.initIndex(ALGOLIA_POSTS_INDEX_NAME);  // Posts  クライアントを初期化
        index.saveObject(newValue);  // algolia上にnewValueをセーブ
        // myBatchは2回しか使用されない
        // postCountのupdateとtimelineのset
        const myBatch = fireStore.batch();  // batchを設定
        const myRef = fireStore.collection('users').doc(newValue.uid);  //自分の投稿のreferenceを設定
        myBatch.update(myRef, {  // batchにreferenceとデータを与える
            'postCount': admin.firestore.FieldValue.increment(plusOne),
        });
        // timelineを作成
        const timeline = {
            'createdAt': newValue.createdAt,
            'isRead': false,
            'postCreatorUid': newValue.uid,
            'postId': newValue.postId,
        };
        // //自分のタイムラインに自分の投稿をセットする
        myBatch.set(myRef.collection('timelines').doc(newValue.postId), timeline);
        await myBatch.commit();

        // // followersをget
        // const followers = await fireStore.collection('users').doc(newValue.uid).collection('followers').get();
        // let count = 0;
        // let batch = fireStore.batch();
        // for(const follower of followers.docs) {
        //     const data = follower.data();
        //     const ref = fireStore.collection('users').doc(data.followerUid).collection('timelines').doc(newValue.postId);  // followerのtimelineを作成
        //     batch.set(ref, timeline);
        //     count++;
        //     if(count == batchLimit) {
        //         await batch.commit();
        //         batch = fireStore.batch();
        //         count = 0;
        //     }
        // }
        // if(count > 0) {
        //     await batch.commit();
        // }
    }
);

exports.onPostDelete = functions.firestore.document('users/{uid}/posts/{postId}').onDelete(
    async (snap,_) => {  // snapにはデータが入っている
        const newValue = snap.data();
        const objectID = snap.id;  // objectIDはalgolia専用のID
        const index = client.initIndex(ALGOLIA_POSTS_INDEX_NAME);  // Posts  クライアントを初期化
        index.deleteObject(objectID);
        const myRef = fireStore.collection('users').doc(newValue.uid);
        await myRef.update({
            'postCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
//---------------------------------------------------------------------------------------------------------