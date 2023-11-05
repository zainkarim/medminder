import cv2
import dlib
import numpy as np
import time
from imutils import face_utils
import os

# Open camera
cap = cv2.VideoCapture(0)
if not cap.isOpened():
    print("Cannot open camera")
    exit()

# Load facial landmark predictor
predictor_path = "shape_predictor_68_face_landmarks.dat"
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor(predictor_path)

# Define eye aspect ratio function
def eye_aspect_ratio(eye):
    A = np.linalg.norm(eye[1] - eye[5])
    B = np.linalg.norm(eye[2] - eye[4])
    C = np.linalg.norm(eye[0] - eye[3])
    ear = (A + B) / (2.0 * C)
    return ear

# Thresholds and counters
EYE_AR_THRESH = 0.3
EYE_AR_CONSEC_FRAMES = 48
FACE_NOT_DETECTED_THRESHOLD = 3  # seconds

# Initialize the frame counter and a boolean used to indicate if the alarm is going off
COUNTER = 0
ALARM_ON = False
LAST_FACE_DETECTED_TIME = time.time()

# Start the video stream
while True:
    ret, frame = cap.read()
    if not ret:
        print("Can't receive frame (stream end?). Exiting ...")
        break

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    rects = detector(gray, 0)

    # If faces are detected
    if rects:
        LAST_FACE_DETECTED_TIME = time.time()  # Reset the timer whenever a face is detected
        for rect in rects:
            shape = predictor(gray, rect)
            shape = face_utils.shape_to_np(shape)

            # Draw rectangle around the face
            (x, y, w, h) = face_utils.rect_to_bb(rect)
            cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)

            # Draw circles around the eyes
            leftEye = shape[42:48]
            rightEye = shape[36:42]
            leftEAR = eye_aspect_ratio(leftEye)
            rightEAR = eye_aspect_ratio(rightEye)
            
            for (x, y) in shape[36:48]:
                cv2.circle(frame, (x, y), 1, (0, 0, 255), -1)

            ear = (leftEAR + rightEAR) / 2.0
            print("EAR: {:.2f}".format(ear))  # Terminal output for debugging

            if ear < EYE_AR_THRESH:
                COUNTER += 1

                if COUNTER >= EYE_AR_CONSEC_FRAMES:
                    if not ALARM_ON:
                        ALARM_ON = True
                        # Trigger alarm
                        os.system('afplay chime.mp3')
                        cv2.putText(frame, "ALERT! Please pay attention to the road!", (10, 30),
                                    cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 2)
            else:
                COUNTER = 0
                ALARM_ON = False
    else:
        # If no face is detected, check how much time has passed
        if (time.time() - LAST_FACE_DETECTED_TIME) > FACE_NOT_DETECTED_THRESHOLD:
            if not ALARM_ON:
                ALARM_ON = True
                # Trigger alarm
                os.system('afplay chime.mp3')
                cv2.putText(frame, "ALERT! No driver detected!", (10, 30),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 2)
        else:
            ALARM_ON = False

    # Display the resulting frame with overlays
    cv2.imshow('Frame', frame)

    # Break the loop when 'q' key is pressed
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release the capture and destroy all windows when everything is done
cap.release()
cv2.destroyAllWindows()
