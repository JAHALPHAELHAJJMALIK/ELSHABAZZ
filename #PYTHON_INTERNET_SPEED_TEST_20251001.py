import speedtest as st

def Speed_Test():
    test = st.Speedtest()
    down_speed = test.download()
    down_speed = round(down_speed / 10**6, 2)
    print("ISP Internet Download Speed in  🚀 Mbps: ", down_speed)
    
    up_speed = test.upload()
    up_speed = round(up_speed / 10**6, 2)
    print("ISP Internet Upload Speed in  🚀 Mbps: ", up_speed)
    
    ping = test.results.ping
    print("Ping: ", ping)
    
    return

Speed_Test()







# import speedtest

# st = speedtest.Speedtest()

# print("Testing download speed...")
# download_speed = st.download() / 1_000_000  # Convert to Mbps
# print(f"Download: {download_speed:.2f} Mbps")

# print("Testing upload speed...")
# upload_speed = st.upload() / 1_000_000      # Convert to Mbps
# print(f"Upload:   {upload_speed:.2f} Mbps")

# print(f"Ping:     {st.results.ping:.2f} ms")







# -- ======================================
	# -- NOTE(S) / COMMENT(S): 
# -- ======================================
# JAH THANK YOU JAH INTERNET SPEED TEST VIA CMD PROMPT #PYTHON

        # Install the package (run in terminal/CMD):tpip install speedtest-cli
        # Install the package (run in terminal/CMD):textpip install speedtest-cli
		# ping -n 20 8.8.8.8
		# ping -n 20 google.com

# internet speed (primarily download/upload bandwidth and latency) can be tested effectively from both the Command Prompt (CMD) and Python, though pure native CMD has limitations for full bandwidth testing.
# Testing via Command Prompt (Windows CMD)
# Native Windows commands like ping provide only basic latency and connectivity information, not actual bandwidth speed.
# Basic latency test (native, no installation required):

# Open Command Prompt.
# Execute:textping -n 20 google.comortextping -n 20 8.8.8.8
# This measures round-trip time (latency) in milliseconds and packet loss. It does not measure download/upload throughput.

# For accurate download/upload speed testing from CMD, you must use a dedicated tool. The most reliable and widely recommended option is the official Speedtest CLI by Ookla (the company behind speedtest.net).
# Recommended method – Official Speedtest CLI:

# Download the Windows version from the official site:
# https://www.speedtest.net/apps/cli
# (Direct download link typically provided there for the .zip file containing speedtest.exe.)
# Extract the archive.
# Open Command Prompt in the folder containing speedtest.exe (or add it to your PATH).
# Run:textspeedtest.exeor for simpler output:textspeedtest.exe --simple

# This provides download speed, upload speed, ping, and jitter — comparable to the browser version of Speedtest.net.
# Alternative lightweight CLI tools exist (e.g., fast-cli via npm, or librespeed-cli), but the official Ookla version remains the most accurate and trusted for general use.
# Testing via Python
# The most common and straightforward approach uses the speedtest-cli library, which wraps Speedtest.net servers.
# Using speedtest-cli (recommended):

# Use this simple script:

# Pythonimport speedtest

# st = speedtest.Speedtest()

# print("Testing download speed...")
# download_speed = st.download() / 1_000_000  # Convert to Mbps
# print(f"Download: {download_speed:.2f} Mbps")

# print("Testing upload speed...")
# upload_speed = st.upload() / 1_000_000      # Convert to Mbps
# print(f"Upload:   {upload_speed:.2f} Mbps")

# print(f"Ping:     {st.results.ping:.2f} ms")
# Without external libraries (manual implementation):
# You can measure approximate download speed by timing how long it takes to download a known-size file from a fast server (e.g., a test file from a cloud provider or CDN).
# Example:
# Pythonimport requests
# import time

# url = "http://speedtest.tele2.net/100MB.zip"   # 100 MB test file
# print("Downloading test file...")

# start_time = time.time()
# response = requests.get(url, stream=True)
# total_bytes = 0

# for chunk in response.iter_content(chunk_size=8192):
    # total_bytes += len(chunk)

# end_time = time.time()
# duration = end_time - start_time

# speed_mbps = (total_bytes * 8) / (duration * 1_000_000)   # bits per second → Mbps

# print(f"Downloaded {total_bytes / 1_000_000:.1f} MB in {duration:.2f} s")
# print(f"Approximate download speed: {speed_mbps:.2f} Mbps")
# This method is less accurate than dedicated tools (no multi-connection, no server selection, no upload test), but requires only requests (or even just urllib).
# Summary – Recommended Approaches

# MethodRequires InstallDownloadUploadLatencyAccuracyNotesping (native CMD)NoNoNoYes—Latency & reachability onlyOfficial Speedtest CLIYes (small exe)YesYesYesHighBest overall CMD solutionPython + speedtest-cliYes (pip)YesYesYesHighMost convenient for scriptingPython + manual downloadMinimalApproxNoPartialMediumQuick & dirty, no upload
# For serious or repeated testing, use either the official Speedtest CLI from CMD/PowerShell or the speedtest-cli Python library. Both produce reliable, production-grade results.
