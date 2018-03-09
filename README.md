# Steps

Generate Jooq classes

```
./gradlew generateMainJooqSchemaSource
```

Start Spring Boot application
```
./gradlew bootRun
```

Call failing endpoint
```
curl -X POST \
  http://localhost:8080/api/v1/tarif/porte \
  -H 'content-type: application/json' \
  -d '{
	"quantity": "5",
	"isAlu": "true",
	"isPVC": "false",
	"isOscillo": "true",
	"isBattante": "false"
}'
```
