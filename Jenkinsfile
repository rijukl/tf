pipeline {
  agent any 
  
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    stages {
        stage('Checkout') {
            steps {
                withAWS(region: 'us-east-1', credentials: 'awsid') {
                    git branch: 'main', url: 'https://github.com/rijukl/tf.git'
                }
            }
        }
        stage('Run terraform') {
            steps {
                container('terraform') {
                    sh 'terraform version'
                }
            }
        } 
        stage('Terraform Init') {
            steps {
                container('terraform') {
                    sh 'terraform init'
                }
            }
        }
        stage('Plan') {
            steps {
                withAWS(region: 'us-east-1', credentials: 'awsid') {
                    container('terraform') {
                        sh 'terraform plan -out tfplan'
                        sh 'terraform show -no-color tfplan > tfplan.txt'
                    }
                }    
            }
        }
        stage('Apply / Destroy') {
            steps {
                withAWS(region: 'us-east-2', credentials: 'awsid') {
                    script {
                        container('terraform') {
                            if (params.action == 'apply') {
                                if (!params.autoApprove) {
                                    def plan = readFile 'tfplan.txt'
                                    input message: "Do you want to apply the plan?",
                                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                                }

                                sh 'terraform ${action} -input=false tfplan'
                            } else if (params.action == 'destroy') {
                                sh 'terraform ${action} --auto-approve'
                            } else {
                                error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                            }
                        }
                    }
                }    
            }
        }
    }
}
