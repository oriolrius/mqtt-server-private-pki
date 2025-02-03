# Load environment variables from .env file
set dotenv-load

ssl_client:
  openssl s_client ${MQTT_HOST}:${MQTT_PORT}

ssl_client_with_cacert:
  openssl s_client \
      -CAfile ${CA_FILE} \
      ${MQTT_HOST}:${MQTT_PORT}

ssl_client_with_cacert_and_client_cert:
  openssl s_client \
      -CAfile ${CA_FILE} \
      -cert ${CERT_FILE} \
      -key ${KEY_FILE} \
      -pass "pass:${KEY_PASSPHRASE}" \
      ${MQTT_HOST}:${MQTT_PORT}

pub_letsencrypt +ARGS:
  mosquitto_pub \
      -d -h ${MQTT_HOST} -p ${MQTT_PORT} {{ ARGS }}

sub_letsencrypt +ARGS:
  mosquitto_sub \
      -d -h ${MQTT_HOST} -p ${MQTT_PORT} {{ ARGS }}

pub_with_cacert +ARGS:
  mosquitto_pub \
      --cafile ${CA_FILE} \
      -d -h ${MQTT_HOST} -p ${MQTT_PORT} {{ ARGS }}

sub_with_cacert +ARGS:
  mosquitto_sub \
      --cafile ${CA_FILE} \
      -d -h ${MQTT_HOST} -p ${MQTT_PORT} {{ ARGS }}

pub_with_client_certificate +ARGS: 
  mosquitto_pub \
      --cafile ${CA_FILE} \
      --cert ${CERT_FILE} \
      --key ${KEY_FILE} \
      -d -h ${MQTT_HOST} -p ${MQTT_PORT} {{ ARGS }}

sub_with_client_certificate +ARGS:
  mosquitto_sub \
      --cafile ${CA_FILE} \
      --cert ${CERT_FILE} \
      --key ${KEY_FILE} \
      -d -h ${MQTT_HOST} -p ${MQTT_PORT} {{ ARGS }}

install_uv:
  curl -LsSf https://astral.sh/uv/install.sh | sh

sync:
  uv sync
  
py_pub:
  uv run mqtt_pub.py

py_sub:
  uv run mqtt_sub.py
