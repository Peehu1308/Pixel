const amplifyconfig = '''{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "pixel": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://nla3chcv2vcb7hqd6hy54ypgdi.appsync-api.ap-south-1.amazonaws.com/graphql",
                    "region": "ap-south-1",
                    "authorizationType": "API_KEY",
                    "apiKey": "da2-mmrw3a26wnhzdcngpkqhjlg6ym"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "ap-south-1:a6de3803-0625-4640-adbe-7ec78b7e25d8",
                            "Region": "ap-south-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "ap-south-1_ZBnnciBQK",
                        "AppClientId": "72jm8nhho2nqplfn2bchg8p7fr",
                        "Region": "ap-south-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "signupAttributes": [
                            "EMAIL"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [
                            "SMS"
                        ],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "pixelbuckete0c67-dev",
                        "Region": "ap-south-1"
                    }
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://nla3chcv2vcb7hqd6hy54ypgdi.appsync-api.ap-south-1.amazonaws.com/graphql",
                        "Region": "ap-south-1",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-mmrw3a26wnhzdcngpkqhjlg6ym",
                        "ClientDatabasePrefix": "pixel_API_KEY"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "pixelbuckete0c67-dev",
                "region": "ap-south-1",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';
