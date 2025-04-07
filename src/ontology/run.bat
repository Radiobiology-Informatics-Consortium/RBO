docker run --env ROBOT_JAVA_ARGS=-Xmx12G -v %cd%\..\..\:/work -w /work/src/ontology --rm -i --memory=12g obolibrary/odkfull %*
