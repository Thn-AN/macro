import pyautogui
import time
import keyboard
import threading

# Global flag to control when the automation should stop
running = True
start_key = "["
stop_key = "]"

def initialise_start(speed, delay):
    # Loop 10 times
    for _ in range(10):
        if not running:
            return  # Stop if the flag is set to False
        pyautogui.typewrite('o')
        time.sleep(delay)

    # First set of mouse movements
    pyautogui.moveTo(28, 1043, duration=speed)
    time.sleep(delay)
    pyautogui.click()
    time.sleep(delay)

    pyautogui.moveTo(1220, 420, duration=speed)
    pyautogui.scroll(-2000)  # Negative value to scroll down
    time.sleep(delay)
    pyautogui.click()
    time.sleep(delay)

    pyautogui.moveTo(1343, 180, duration=speed)
    time.sleep(delay)
    pyautogui.click()
    time.sleep(delay)

    pyautogui.moveTo(878, 181, duration=speed)
    time.sleep(delay)
    pyautogui.click()

def automate_task():
    global running
    speed = 0.5
    delay = 0.1  # Converted to seconds
    initialise_start(speed, delay)


    # Infinite loop (until stop key is pressed)
    idx_char = 1
    coord_multi = 0

    while running:  # Check the running flag
        for _ in range(4):
            if not running:
                return  # Exit function if the flag is set to False
            pyautogui.typewrite(str(idx_char))
            pyautogui.moveTo(830 - (coord_multi * 0.1), 579 + coord_multi * 0.8, duration=speed)
            pyautogui.click()
            time.sleep(delay)

            pyautogui.typewrite('t')
            time.sleep(delay)

            for _ in range(4):
                if not running:
                    return  # Exit function if the flag is set to False
                pyautogui.typewrite(str(idx_char))
                pyautogui.moveRel(60 + (coord_multi * 0.005), 0, duration=speed)
                pyautogui.click()
                time.sleep(delay)

                pyautogui.typewrite('t')
                time.sleep(delay)

                pyautogui.typewrite('q')

            idx_char = (idx_char % 4) + 1
            coord_multi = (coord_multi % 300) + 75

            pyautogui.moveTo(1178, 839, duration=speed)
            pyautogui.click()

            pyautogui.moveTo(878, 181, duration=speed)
            pyautogui.click()

def on_esc_press():
    print("Esc key pressed. Running automation...")
    automate_task()

# Listener for the stop key (F12)
def stop_automation():
    global running
    print("F12 key pressed. Stopping automation...")
    running = False  # Set the flag to False to stop the automation

def listen_for_key():
    keyboard.wait(start_key)  # Wait until the 'Esc' key is pressed to start
    on_esc_press()

# Start the listener for the stop key (F12) in a separate thread
def start_stop_listener():
    keyboard.add_hotkey(stop_key, stop_automation)

# Start both key listeners in separate threads
key_listener_thread = threading.Thread(target=listen_for_key)
stop_listener_thread = threading.Thread(target=start_stop_listener)

key_listener_thread.start()
stop_listener_thread.start()