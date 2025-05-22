# Permissions for Backstage

```bash
source .env


```bash
az ad app permission add --id $AZURE_CLIENT_ID --api 00000003-0000-0000-c000-000000000000 --api-permissions e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope # User.Read
az ad app permission add --id $AZURE_CLIENT_ID --api 00000003-0000-0000-c000-000000000000 --api-permissions 37f7f235-527c-4136-accd-4a02d197296e=Scope # openid
az ad app permission add --id $AZURE_CLIENT_ID --api 00000003-0000-0000-c000-000000000000 --api-permissions 64a6cdd6-aab1-4aaf-94b8-3cc8405e90d0=Scope # email
az ad app permission add --id $AZURE_CLIENT_ID --api 00000003-0000-0000-c000-000000000000 --api-permissions 7427e0e9-2fba-42fe-b0c0-848c9e6a8182=Scope # offline_access
az ad app permission add --id $AZURE_CLIENT_ID --api 00000003-0000-0000-c000-000000000000 --api-permissions 14dad69e-099b-42c9-810b-d002981feec1=Scope # profile

az ad app permission add --id $AZURE_CLIENT_ID --api 00000003-0000-0000-c000-000000000000 --api-permissions df021288-bdef-4463-88db-98f22de89214=Role # User.Read.All
az ad app permission add --id $AZURE_CLIENT_ID --api 00000003-0000-0000-c000-000000000000 --api-permissions 98830695-27a2-44f7-8c18-0c3ebc9698f6=Role # GroupMember.Read.All

# Wait for the permissions to be granted
sleep 30

# Grant admin consent
az ad app permission admin-consent --id $AZURE_CLIENT_ID


az ad app update --id ${AZURE_CLIENT_ID} --web-redirect-uris "http://localhost:7007/api/auth/microsoft/handler/frame"

```