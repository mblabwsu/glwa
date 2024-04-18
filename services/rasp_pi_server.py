import RPi.GPIO as GPIO
from flask import Flask, request
from pyngrok import ngrok
from time import sleep

app = Flask(__name__)
GPIO.setmode(GPIO.BOARD)
GPIO.setup(18, GPIO.OUT)

@app.route('/control', methods=['Post'])
def control():
    data = request.get_json()
    pin_state = data['pin_state']

    if pin_state == 'on':
        GPIO.output(18, GPIO.HIGH)

    if pin_state == 'off':
        GPIO.output(18, GPIO.LOW)

    return {'success': True}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
    ngrok_tunnel = ngrok.connect(5000)
    print('Ngrok URL:' , ngrok_tunnel.public_url)