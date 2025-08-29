# Set up of OpenDataHub or RHOAI (with or without GPUs) for RHDH AI Model Catalog testing

Latest functional testing shows you need OCP 4.16 or greater.  It has been verified for as recent a version as 4.19. 

## Install via kustomize

From a clone of this repo, run from the same directory as this README:

### ODH

```shell
oc apply -k ./kustomize/
```

### RHOAI

```shell
oc apply -k ./kustomize-rhoai/
```

### GPUs

If you provisioned a cluster with GPUs, run this kustomize before running either the ODH or RHOAI kustomizes

```shell
oc apply -k ./kustomize-gpu
```

The `NodeFeature` subscription is OCP version specific.  The `nodefeature-subscription.yaml` currently references a 
4.19 version.  You can edit that file for your OCP version, and run the contents of the `kustomize-gpu/job.yaml` Job
manually:

```shell
bash ./subscriptions-gpu.sh
bash ./cpu-setup.sh
bash ./nfd-setup.sh
# this will clean up status files created during the subscriptions setup
rm *.txt
```

## Set up LlamaStack operator and a LlamaStack instance

So the [Running LlamaStack Operator with ODH](https://github.com/opendatahub-io/llama-stack-k8s-operator/blob/odh/docs/odh/llama-stack-with-odh.md) instructions,
after some minor modifications, were able to produce: 
- a running llama 3.2 3B instruct model as vLLM Nvidia GPU KServe InferenceService instance in the `llamastack` namespace.
- a running llama-stack instance that uses the llama 3.2 3B instruct model

Tweaks to the instructions there include:
- The UI / Dashboard flow [directions](https://github.com/opendatahub-io/llama-stack-k8s-operator/blob/odh/docs/odh/llama-stack-with-odh.md#2-deploy-llama-32-model-via-kserve-ui) do not line up exactly with the 2.33 ODH console on OCP.  Instead, go into the `llamastack` project create by the `kustomize-gpu` Job, and select single server model serving for the `llamastack` project
- Then click the `Connections` tab near the top
- Click Create a new Connection
- The values for Connection name, type, and URI for `Create a Connection` are still correct.
- For deploying the model, while still in the `llamastack` project, click the `Models` tab near th top
- Click the deploy a model button
- The specific field settings in the instructions are still correct for those fields mentioned
- But also select the expose the model by a route, and disable authentication.
- When creating the `LlamaStackDistribution` CR in step three, using the service URL for `VLLM_URL` did not work.  Changing it to the URL of the `Route` created for the model does work (where you add the `/v1` suffix to the `Route` URL)
- Also, set the `mountPath` in the last line to the default
- You'll have to create your own `LlamaStackDistribution` yaml for your cluster, but a reference example exists in the file `llamastackdistribution-gabe-pers-cluster.yaml`.
- Lastly, the various python snippets in [Query the Model from Jupyter Notebook](https://github.com/opendatahub-io/llama-stack-k8s-operator/blob/odh/docs/odh/llama-stack-with-odh.md#5-query-the-model-from-jupyter-notebook) have been put in the file `jupyter-nb-test.py` file for convenience.  And similarly to the prior steps, the UI / Dashboard navigation directions don't quite line up with what you will see with ODH 2.33 running on OCP.  Assuming you are still in the `llamastack` project, click the `Workbenches` tab near the top, create a new notebook, and go from there.  As long as a 3.12 python workbook type is chosen, so far, any of those choices seem to be OK.