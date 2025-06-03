from flask import Flask, request, send_file
import subprocess
import os
from datetime import datetime

app = Flask(__name__)

@app.route('/take_photo', methods=['GET'])
def take_photo():
    filename = f"timelapse_{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.jpg"
    filepath = "/tmp/{}".format(filename)
    #command = "gst-launch-1.0 v4l2src device=/dev/video0 io-mode=4 num-buffers=1 ! autovideoconvert ! video/x-raw,format=UYVY,width=1920,height=1080 ! jpegenc ! filesink location=photo.jpg"
    command = "gst-launch-1.0 v4l2src device=/dev/video-camera0 io-mode=4 num-buffers=3 ! autovideoconvert ! video/x-raw,format=UYVY,width=2592,height=1944 ! jpegenc ! multifilesink location={}".format(filepath)
    subprocess.run(command, shell=True)

    # Return the photo as a response
    return send_file(
        filepath,
        download_name=filename,
        mimetype='image/jpeg')

if __name__ == '__main__':
    app.run(port=10000, host="0.0.0.0")

