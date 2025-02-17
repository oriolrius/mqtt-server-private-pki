# Load environment variables from .env file
set dotenv-load
# mqttx-cli using docker
mqttx-cli := 'docker run -it --rm --entrypoint /usr/local/bin/mqttx -v ./${CA_FILE}:/tmp/ca.crt emqx/mqttx-cli'

mqtt:
  cd mosquitto && mosquitto -c mosquitto.conf

ssl_client:
  openssl s_client ${MQTT_HOST}:${MQTT_PORT}

ssl_client_with_cacert:
  openssl s_client \
      -CAfile ${CA_FILE} \
      ${MQTT_HOST}:${MQTT_PORT}

pub_with_cacert +ARGS:
  mosquitto_pub \
      --cafile ${CA_FILE} \
      -d -h ${MQTT_HOST} -p ${MQTT_PORT} \
      -t hello -m "moquitto clients" {{ ARGS }}

sub_with_cacert +ARGS:
  mosquitto_sub \
      --cafile ${CA_FILE} \
      -d -h ${MQTT_HOST} -p ${MQTT_PORT} \
      -v -t hello {{ ARGS }}

mqttx_sub:
  {{mqttx-cli}} sub \
    --ca /tmp/ca.crt \
    -h mqtt.example.tld \
    -p 8884 -l wss \
    -t topic1

mqttx_pub:
  {{mqttx-cli}} pub \
    --ca /tmp/ca.crt \
    -h mqtt.example.tld \
    -p 8883 -l mqtts \
    -t topic1 -m message1

install_uv:
  curl -LsSf https://astral.sh/uv/install.sh | sh

sync:
  uv sync
  
py_pub:
  uv run python_client/mqtt_pub.py

py_sub:
  uv run python_client/mqtt_sub.py
