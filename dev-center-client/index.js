const { DefaultAzureCredential } = require("@azure/identity");
const { isUnexpected, getLongRunningPoller } = require("@azure-rest/developer-devcenter");
const createClient = require("@azure-rest/developer-devcenter").default;
const { setLogLevel } = require("@azure/logger");
require("dotenv").config();

const express = require('express');
const app = express();

const port = 3000;

setLogLevel("info");

app.get('/', (req, res) => {
    res.send('Hello World!');
});

app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`);
});

// Get Projects
app.get('/projects', async (req, res) => {
    const endpoint = process.env.DEVCENTER_ENDPOINT || "<devcenter name>";
    const client = createClient(endpoint, new DefaultAzureCredential());

    console.log(client);

    console.log("Endpoint: ", endpoint);

    const projectList = await client.path("/projects").get();
    if (isUnexpected(projectList)) {
        throw new Error(projectList.body.error);
    }

    console.log("Projects: ", projectList.body.value);

    res.send(projectList.body.value);
});

// Get pools for a project
app.get('/projects/:projectName/pools', async (req, res) => {
    const endpoint = process.env.DEVCENTER_ENDPOINT || "<devcenter name>";
    const client = createClient(endpoint, new DefaultAzureCredential());
    console.log("Endpoint: ", endpoint);
    console.log("ProjectName: ", req.params.projectName);
    const poolList = await client.path("/projects/{projectName}/pools", req.params.projectName).get();

    console.log("PoolList: ", poolList);

    if (isUnexpected(poolList)) {
        throw new Error(poolList.body.error);
    }
    console.log("Pools: ", poolList.body.value);
    res.send(poolList.body.value);
}
);

//Get DevBoxs for the user logged in
app.get('/devboxes', async (req, res) => {
    const endpoint = process.env.DEVCENTER_ENDPOINT || "<devcenter name>";
    const client = createClient(endpoint, new DefaultAzureCredential());

    console.log("Endpoint: ", endpoint);

    const devBoxList = await client.path("/devboxes").get();
    if (isUnexpected(devBoxList)) {
        throw new Error(devBoxList.body.error);
    }

    console.log("DevBoxes: ", devBoxList.body.value);

    res.send(devBoxList.body.value);
});

// Get DevBoxes for a specific user
app.get('/devboxes/:userId', async (req, res) => {
    const endpoint = process.env.DEVCENTER_ENDPOINT || "<devcenter name>";
    const client = createClient(endpoint, new DefaultAzureCredential());

    console.log("Endpoint: ", endpoint);
    console.log("UserId: ", req.params.userId);

    console.log("/users/{userId}/devboxes", req.params.userId);

    const devBoxList = await client.path(`/users/${req.params.userId}/devboxes`).get();
    if (isUnexpected(devBoxList)) {
        throw new Error(devBoxList.body.error);
    }

    console.log("DevBoxes: ", devBoxList.body.value);

    res.send(devBoxList.body.value);
});


// Create a DevBox for a specific user
app.post('/devboxes/:projectName/:userId', async (req, res) => {
    const endpoint = process.env.DEVCENTER_ENDPOINT || "<devcenter name>";
    const client = createClient(endpoint, new DefaultAzureCredential());

    console.log("Endpoint: ", endpoint);
    console.log("UserId: ", req.params.userId);
    console.log("ProjectName: ", req.params.projectName);

    // Get the pool for the project
    const poolList = await client.path("/projects/{projectName}/pools", req.params.projectName).get();

    console.log("PoolList: ", poolList.body.value);

    if (isUnexpected(poolList)) {
        throw new Error(poolList.body.error);
    }

    let pool = poolList.body.value[1];
    if (pool === undefined || pool.name === undefined) {
        throw new Error("No pools found.");
    }

    console.log("Pool selected: ", pool.name);    

    const devBoxCreateParameters = {
        contentType: "application/json",
        body: { poolName: poolName },
    };

    // Provision a dev box
    const devBoxCreateResponse = await client
        .path(
            "/projects/{projectName}/users/{userId}/devboxes/{devBoxName}",
            req.params.projectName,
            req.params.userId,
            "devbox-created-by-api",
        )
        .put(devBoxCreateParameters);

    if (isUnexpected(devBoxCreateResponse)) {

        console.log("Error: ", devBoxCreateResponse.body);

        throw new Error(devBoxCreateResponse.body.message);
    }

    const devBoxCreatePoller = await getLongRunningPoller(client, devBoxCreateResponse);
    const devBoxCreateResult = await devBoxCreatePoller.pollUntilDone();

    console.log(`Provisioned dev box with state ${devBoxCreateResult.body.provisioningState}.`);


    const remoteConnectionResult = await client
        .path(
            "/projects/{projectName}/users/{userId}/devboxes/{devBoxName}/remoteConnection",
            req.params.projectName,
            req.params.userId,
            "devbox-created-by-api",
        )
        .get();

    if (isUnexpected(remoteConnectionResult)) {
        throw new Error(remoteConnectionResult.body.error.message);
    }

    console.log(`Connect using remote connection URL ${remoteConnectionResult.body.webUrl}.`);

});