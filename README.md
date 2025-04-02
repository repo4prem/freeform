Splunk Query
spl
Copy
Edit
index="your-aks-index" 
sourcetype="log4j" 
"kubernetes.namespace_name"="your-namespace"
"kubernetes.container_name"="your-app-container"
("ERROR" OR "INFO") 
| rex field=_raw "(?<log_level>ERROR|INFO) (?<log_message>.*)" 
| table _time log_level log_message kubernetes.pod_name kubernetes.container_name
| sort -_time
Explanation
index="your-aks-index" → Replace your-aks-index with the index storing AKS logs.

sourcetype="log4j" → Filters logs specifically from Log4j.

kubernetes.namespace_name="your-namespace" → Replace with your AKS namespace.

kubernetes.container_name="your-app-container" → Replace with your Spring Boot container name.

("ERROR" OR "INFO") → Filters only logs containing "ERROR" or "INFO".

rex field=_raw "(?<log_level>ERROR|INFO) (?<log_message>.*)" → Extracts log level and message.

table _time log_level log_message kubernetes.pod_name kubernetes.container_name → Displays relevant fields.

sort -_time → Sorts logs by the most recent first.

Example Log Output
_time	log_level	log_message	pod_name	container_name
2025-03-31 14:20:30	ERROR	Exception occurred while processing request	my-app-pod-12345	my-springboot-app
2025-03-31 14:19:10	INFO	User transaction successful	my-app-pod-67890	my-springboot-app
Enhancements
To filter by a specific transaction ID:

spl
Copy
Edit
"transactionId=12345"
To search for logs within the last 24 hours:

spl
Copy
Edit
earliest=-24h@h latest=now
To count errors per pod:

spl
Copy
Edit
stats count by kubernetes.pod_name log_level
Would you like to refine the query further, maybe filter by a specific API request? 🚀







You said:
i want to host a free web page online


ChatGPT said:
If you want to host a free web page online, here are some of the best options depending on your needs:
