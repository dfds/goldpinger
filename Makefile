upgrade:
	helm upgrade goldpinger stable/goldpinger -f values.yaml
	kubectl label services goldpinger scrape-service-metrics="true"

install:
	helm install stable/goldpinger --name goldpinger -f values.yaml
	kubectl label services goldpinger scrape-service-metrics="true"

delete:
	helm delete goldpinger --purge
