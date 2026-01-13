pipeline {
    agent any

    environment {
        CONTAINER_ID = ""
        SUM_PY_PATH = "sum.py"
        DIR_PATH = "."
        TEST_FILE_PATH = "test_variables.txt"
        IMAGE_NAME = "sum-python"
        DOCKERHUB_IMAGE = "moubarakkass99/sum-python"
    }

    stages {

        stage('Build') {
            steps {
                echo "=== Construction de l'image Docker ==="
                bat "docker build -t ${IMAGE_NAME} ${DIR_PATH}"
            }
        }

        stage('Run') {
            steps {
                echo "=== Lancement du conteneur Docker ==="
                script {
                    def output = bat(
                        script: "docker run -d ${IMAGE_NAME}",
                        returnStdout: true
                    )
                    def lines = output.split('\n')
                    CONTAINER_ID = lines[-1].trim()
                    echo "Conteneur démarré : ${CONTAINER_ID}"
                }
            }
        }

        stage('Test') {
            steps {
                echo "=== Exécution des tests ==="
                script {
                    def testLines = readFile(TEST_FILE_PATH).split('\n')

                    for (line in testLines) {
                        if (line.trim() == "") {
                            continue
                        }

                        def vars = line.split(' ')
                        def arg1 = vars[0]
                        def arg2 = vars[1]
                        def expectedSum = vars[2].toFloat()

                        def output = bat(
                            script: "docker exec ${CONTAINER_ID} python /app/sum.py ${arg1} ${arg2}",
                            returnStdout: true
                        )

                        def result = output.split('\n')[-1].trim().toFloat()

                        if (result == expectedSum) {
                            echo "Test réussi : ${arg1} + ${arg2} = ${result}"
                        } else {
                            error "Test échoué : ${arg1} + ${arg2} → attendu ${expectedSum}, obtenu ${result}"
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "=== Déploiement vers DockerHub ==="
                bat "docker login"
                bat "docker tag ${IMAGE_NAME} ${DOCKERHUB_IMAGE}"
                bat "docker push ${DOCKERHUB_IMAGE}"
            }
        }
    }

    post {
        always {
            echo "=== Nettoyage du conteneur Docker ==="
            bat "docker stop ${CONTAINER_ID} || exit 0"
            bat "docker rm ${CONTAINER_ID} || exit 0"
        }
    }
}
