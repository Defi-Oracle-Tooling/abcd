# Azure OpenAI SDK: o3-mini Deployment

## Overview
This document provides example code snippets and instructions for using the Azure OpenAI SDK with the `o3-mini` deployment. For additional information, refer to the [Azure OpenAI SDK documentation](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/).

---

## 1. Authentication Using API Key
To authenticate with the OpenAI API, deploy the model to generate the endpoint URL and an API key. Use these credentials to initialize the SDK client.

### Example:
```javascript
const apiKey = "<your-api-key>";
const apiVersion = "2024-04-01-preview";
const endpoint = "https://dev-l-m8r2apdt-eastus2.cognitiveservices.azure.com/openai/deployments/o3-mini";
const deployment = "o3-mini";
const options = { endpoint, apiKey, deployment, apiVersion };

const client = new AzureOpenAI(options);
```

---

## 2. Install Dependencies
Ensure Node.js is installed. Create a `package.json` file with the following content:

```json
{
  "type": "module",
  "dependencies": {
    "openai": "latest",
    "@azure/identity": "latest"
  }
}
```

Run the following command to install dependencies:
```bash
npm install
```

---

## 3. Basic Code Sample
This example demonstrates a basic call to the chat completion API:

```javascript
import { AzureOpenAI } from "openai";

const endpoint = "https://dev-l-m8r2apdt-eastus2.cognitiveservices.azure.com/openai/deployments/o3-mini";
const modelName = "o3-mini";
const deployment = "o3-mini";

export async function main() {

  const apiKey = "<your-api-key>";
  const apiVersion = "2024-04-01-preview";
  const options = { endpoint, apiKey, deployment, apiVersion }

  const client = new AzureOpenAI(options);

  const response = await client.chat.completions.create({
    messages: [
      { role:"system", content: "You are a helpful assistant." },
      { role:"user", content: "I am going to Paris, what should I see?" }
    ],
    max_completion_tokens: 100000,
      model: modelName
  });

  if (response.status !== "200") {
    throw response.body.error;
  }
  console.log(response.choices[0].message.content);
}

main().catch((err) => {
  console.error("The sample encountered an error:", err);
});
```

## 4. Explore more samples
Run a multi-turn conversation
This sample demonstrates a multi-turn conversation with the chat completion API. When using the model for a chat application, you'll need to manage the history of that conversation and send the latest messages to the model.

```javascript
import { AzureOpenAI } from "openai";

const endpoint = "https://dev-l-m8r2apdt-eastus2.cognitiveservices.azure.com/openai/deployments/o3-mini";
const modelName = "o3-mini";
const deployment = "o3-mini";

export async function main() {

  const apiKey = "<your-api-key>";
  const apiVersion = "2024-04-01-preview";
  const options = { endpoint, apiKey, deployment, apiVersion }

  const client = new AzureOpenAI(options);

  const response = await client.chat.completions.create({
    messages: [
      { role:"system", content: "You are a helpful assistant." },
      { role:"user", content: "I am going to Paris, what should I see?" }
    ],
    max_completion_tokens: 100000,
      model: modelName
  });

  if (response.status !== "200") {
    throw response.body.error;
  }

  for (const choice of response.choices) {
    console.log(choice.message.content);
  }
}

main().catch((err) => {
  console.error("The sample encountered an error:", err);
});
```

## Stream the output
For a better user experience, you will want to stream the response of the model so that the first token shows up early and you avoid waiting for long responses.

```javascript
import { AzureOpenAI } from "openai";

const endpoint = "https://dev-l-m8r2apdt-eastus2.cognitiveservices.azure.com/openai/deployments/o3-mini";
const modelName = "o3-mini";
const deployment = "o3-mini";

export async function main() {

  const apiKey = "<your-api-key>";
  const apiVersion = "2024-04-01-preview";
  const options = { endpoint, apiKey, deployment, apiVersion }

  const client = new AzureOpenAI(options);

  const response = await client.chat.completions.create({
    messages: [
      { role:"system", content: "You are a helpful assistant." },
      { role:"user", content: "I am going to Paris, what should I see?" }
    ],
    stream: true,
    max_completion_tokens: 100000,
      model: modelName
  });

  for await (const part of stream) {
    process.stdout.write(part.choices[0]?.delta?.content || '');
  }
  process.stdout.write('\n');
}

main().catch((err) => {
  console.error("The sample encountered an error:", err);
});
```

## Deployment and Keys

### Endpoint
Target URI="https://dev-l-m8r2apdt-eastus2.cognitiveservices.azure.com/openai/deployments/o3-mini/chat/completions?api-version=2025-01-01-preview"
Key="60WxKWMiHhfqZrCpDrR91ry3DoJR90WlcNq0ke3eObCnSFc4Czt6JQQJ99BCACHYHv6XJ3w3AAAAACOG9lDG"

### Deployment info
Name="o3-mini"
Provisioning state="Succeeded"
Deployment type="Global Batch"
Created on="2025-03-27T08:00:07.2430802Z"
Created by="dev-lead@solacebankcard.com"
Modified on="Mar 27, 2025 1:00 AM"
Modified by="dev-lead@solacebankcard.com"
Version update policy="Once a new default version is available"
Enqueued token limit (thousands)="6.18"
Model name="o3-mini"
Model version="2025-01-31"
Life cycle status="GenerallyAvailable"
Date created="Jan 27, 2025 4:00 PM"
Date updated="Jan 27, 2025 4:00 PM"
Model retirement date="Jan 31, 2026 4:00 PM"

### Monitoring & safety
Content filter="DefaultV2"

Useful links for application development
Code sample repository="https://aka.ms/aoai-codesample-repository"
Tutorial="https://aka.ms/aoai-deployment-tutorial"