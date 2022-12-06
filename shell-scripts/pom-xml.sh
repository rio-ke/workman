pom.xml

model version: 4.0.0
artifiid : sjsj
version: 1.0


awk 'NR >= 5 && NR <= 8 {print $1}' pom.xml
