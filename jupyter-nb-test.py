pip install llama_stack
from llama_stack_client import Agent, AgentEventLogger, RAGDocument, LlamaStackClient
client = LlamaStackClient(base_url="http://llamastack-custom-distribution-service.llamastack.svc.cluster.local:8321")
response = client.inference.chat_completion(
    messages=[
        {"role": "system", "content": "You are a friendly assistant."},
        {"role": "user", "content": "Write a two-sentence poem about llama."}
    ],
    model_id='llama-32-3b-instruct',
)

print(response.completion_message.content)
