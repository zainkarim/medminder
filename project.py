import cv2
import dlib
import numpy as np
import os

# Open camera
cap = cv2.VideoCapture(0)  # '0' is usually the default value for the primary camera.

if not cap.isOpened():
    print("Cannot open camera")
    exit()

# Load facial landmark predictor
predictor_path = "shape_predictor_68_face_landmarks.dat"  # Ensure the model file is in the same directory as your script.
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor(predictor_path)

# Define eye aspect ratio
def eye_aspect_ratio(eye):
    # compute the euclidean distances between the vertical eye landmarks
    A = np.linalg.norm(eye[1] - eye[5])
    B = np.linalg.norm(eye[2] - eye[4])

    # compute the euclidean distance between the horizontal eye landmarks
    C = np.linalg.norm(eye[0] - eye[3])

    # compute the eye aspect ratio
    ear = (A + B) / (2.0 * C)

    return ear

# Monitor the driver
import numpy as np
import time
from imutils import face_utils

EYE_AR_THRESH = 0.3
EYE_AR_CONSEC_FRAMES = 48  # for example, if you want to trigger the alarm after 3 seconds, and your webcam has a framerate of 16 fps

# Initialize the frame counter as well as a boolean used to indicate if the alarm is going off.
COUNTER = 0
ALARM_ON = False

while True:
    ret, frame = cap.read()
    if not ret:
        print("Can't receive frame (stream end?). Exiting ...")
        break

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    rects = detector(gray, 0)

    for rect in rects:
        shape = predictor(gray, rect)
        shape = face_utils.shape_to_np(shape)

        leftEye = shape[42:48]
        rightEye = shape[36:42]
        leftEAR = eye_aspect_ratio(leftEye)
        rightEAR = eye_aspect_ratio(rightEye)

        ear = (leftEAR + rightEAR) / 2.0

        if ear < EYE_AR_THRESH:
            COUNTER += 1

            if COUNTER >= EYE_AR_CONSEC_FRAMES:
                if not ALARM_ON:
                    ALARM_ON = True
                    # Put the code to trigger your chime or alarm here
                    print("ALERT! Please pay attention to the road!")

        else:
            COUNTER = 0
            ALARM_ON = False

    # Display the resulting frame
    cv2.imshow('Frame', frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# When everything done, release the capture
cap.release()
cv2.destroyAllWindows()

if ALARM_ON:
    os.system('afplay /path/to/sound/file.mp3')
