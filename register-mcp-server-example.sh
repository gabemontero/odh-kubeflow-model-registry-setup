# from https://github.com/llamastack/llama-stack-client-python/blob/main/src/llama_stack_client/resources/toolgroups.py and the register command, there appears
# to be a 'extra_headers' param of type 'Headers', which is from src/llama_stack_client/_types.py is a Headers = Mapping[str, Union[str, Omit]] so 
# we can try setting the bearer token with it 
curl -X POST localhost:8321/v1/toolgroups -H "Content-Type: application/json" --data '{ "provider_id" : "model-context-protocol", "toolgroup_id" : "mcp::filesystem", "extra_headers": "Authorization: Bearer 7e8df44ab479b9f089698f312732a02f","mcp_endpoint" : { "uri" : "https://rhdh-mcp-proxy-apicast-production.apps.rosa.redhat-ai-dev.m6no.p3.openshiftapps.com:443/api/mcp-actions/v1"}}'
