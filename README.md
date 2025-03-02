# WarmerService 🔥

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/roberjo/warmerservice)
[![GitHub stars](https://img.shields.io/github/stars/roberjo/warmerservice?style=social)](https://github.com/roberjo/warmerservice)
[![GitHub issues](https://img.shields.io/github/issues/roberjo/warmerservice)](https://github.com/roberjo/warmerservice/issues)

<div align="center">
  [![image](https://github.com/user-attachments/assets/2d825646-0db1-4a03-807c-9819d6685862)
  <br>
  <strong>A robust and efficient endpoint warming utility</strong>
</div>

---

## 📊 Overview

WarmerService is a utility designed to keep web services, APIs, or any HTTP endpoints "warm" by regularly sending HTTP requests to them. This can be particularly useful for:

- 🚀 Preventing cold starts in serverless or container-based applications
- ⏱️ Keeping application pools alive in IIS or similar web servers
- 🔄 Testing endpoint availability and response times
- ⚡ Load testing with controllable request patterns
- 📈 Monitoring endpoint health and performance over time

## ✨ Features

- 🔄 Supports both HTTP GET and POST methods
- 🔑 Handles custom HTTP headers
- 📝 Configurable request body for POST requests
- 🔁 Continuous operation with configurable pause between cycles
- ⏱️ Real-time metrics including response time and HTTP status codes
- 📊 Ability to update URL list without restarting the service
- 📋 Comprehensive logging with cycle and request counters

## 🔧 Requirements

- PowerShell 5.1 or higher
- Internet connectivity to reach the specified endpoints

## 📥 Installation

1. Clone the repository:
```bash
git clone https://github.com/roberjo/warmerservice.git
```

2. Navigate to the directory:
```bash
cd warmerservice
```

3. Create a URL list file according to the format specified below

## 🚀 Usage

### Basic Usage

```powershell
.\url-requester.ps1 -InputFile "urls.txt"
```

### URL List File Format

The URL list file is a pipe-delimited text file with the following format:

#### For GET requests:
```
URL|GET|Header Key:Value,Another-Header:Value
```

#### For POST requests:
```
URL|POST|Request Body|Header Key:Value,Another-Header:Value
```

### Example URL List File

```
https://api.example.com/health|GET
https://api.example.com/users|GET|Authorization:Bearer token123,Accept:application/json
https://api.example.com/data|POST|{"id": 1, "action": "refresh"}|Content-Type:application/json
```

## 📋 Output

<div align="center">
  <img src="https://raw.githubusercontent.com/roberjo/warmerservice/main/docs/screenshot.png" alt="WarmerService Output Screenshot" width="600">
</div>

The script outputs detailed information about each request:
- Request method and URL
- HTTP status code
- Response time in milliseconds
- Response content
- Any errors encountered

Example output:
```
===== Starting Cycle #3 =====
[3.1] Processing: https://api.example.com/health with method GET
[3.1] Status: 200 | Time: 324.56 ms
[3.1] Response:
{"status":"healthy","uptime":"3d 2h 15m"}

[3.2] Processing: https://api.example.com/users with method GET
[3.2] Status: 200 | Time: 455.12 ms
...
```

## ⏹️ Stopping the Service

The script runs in an infinite loop until manually stopped. To stop execution, press `Ctrl+C` in the PowerShell console.

## ⚙️ Advanced Configuration

You can modify the following parameters in the script:

- Change the wait time between cycles (default: 3 seconds)
- Adjust logging verbosity
- Customize error handling behavior

## 🔍 Performance Stats

| Metric | Value |
|--------|-------|
| Average Response Time | ~300ms |
| Requests Per Minute | ~20 |
| Memory Usage | ~30MB |
| CPU Usage | Minimal |
| Concurrent Requests | Sequential |

## 🛠️ Troubleshooting

If you encounter issues:

1. Verify network connectivity to the target endpoints
2. Check for valid URL formats and headers in your URL list file
3. Ensure you have proper permissions to make the requested HTTP calls
4. Check for any firewall or proxy settings that might block requests

<details>
<summary>Common Error Codes</summary>

| Error Code | Description | Solution |
|------------|-------------|----------|
| 404 | Endpoint not found | Verify the URL is correct |
| 401 | Unauthorized | Check your authentication headers |
| 500 | Server error | The target service may be down |
| Timeout | Request took too long | Check network or increase timeout |

</details>

## 📜 License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This script is provided under the MIT License. See the LICENSE file for details.

## 🤝 Contributing

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

Contributions, bug reports, and feature requests are welcome! Feel free to submit issues or pull requests.

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=roberjo/warmerservice&type=Date)](https://star-history.com/#roberjo/warmerservice&Date)

## 📊 Activity

![Alt](https://repobeats.axiom.co/api/embed/your-repobeats-id.svg "Repobeats analytics image")

## 📞 Contact

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://linkedin.com/in/roberjo)
[![GitHub followers](https://img.shields.io/github/followers/roberjo?style=social)](https://github.com/roberjo)
