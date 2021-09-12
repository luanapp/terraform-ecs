[
  {
    "environment": [
        { "name": "NODE_ENV", "value": "${var.environment}" },
        { "name": "MONGO_URI", "value": "${var.mongo_uri}" },
        { "name": "GEOCODER_PROVIDER", "value": "${var.geocoder_provider}" },
        { "name": "GOOGLE_GEOCODING_API_KEY", "value": "${var.geocoder_geocoding_api_key}" },
        { "name": "GEOCODER_LANGUAGE", "value": "${var.geocoder_language}" },
        { "name": "MONGODB_INDEX_LOCALE", "value": "${var.mongo_index_locale}" },
        { "name": "JWT_HASH_KEY", "value": "${var.jwt_hash_key}" },
        { "name": "APP_NAME", "value": "${var.app_name}" },
        { "name": "APP_ID", "value": "${var.app_id}" }
    ],
    "essential": true,
    "image": "${var.image}",
    "name": "${var.service_name}",
    "portMappings": [
      {
        "containerPort": ${var.container_port},
        "hostPort": ${var.host_port}
      }
    ]
  }
]
