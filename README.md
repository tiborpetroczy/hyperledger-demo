# Hyperledger Fabric Demo Consortium

## Fabric structure

- 3 organizations
  - org1.netbuild.hu
  - org2.netbuild.hu
  - org3.netbuild.hu
- 1 CA per organization (all containers 3)
  - ca.org1.netbuild.hu
  - ca.org2.netbuild.hu
  - ca.org3.netbbuild.hu
- 2 peers per organization (all containers 6)
  - peer0.org1.netbuild.hu
  - peer1.org1.netbuild.hu
  - peer0.org2.netbuild.hu
  - peer1.org2.netbuild.hu
  - peer0.org3.netbuild.hu
  - peer1.org3.netbuild.hu
- 1 orderes per organization (all containers 3)
  - orderer.org1.netbuild.hu
  - orderer.org2.netbuild.hu
  - orderer.org3.netbiuld.hu
- 1 CouchDB per peer (all containers 6)
  - couchdb0.org1.netbuild.hu => peer0.org1.netbuild.hu
  - couchdb1.org1.netbuild.hu => peer1.org1.netbuild.hu
  - couchdb0.org2.netbuild.hu => peer0.org2.netbuild.hu
  - couchdb1.org2.netbuild.hu => peer1.org2.netbuild.hu
  - couchdb0.org3.netbuild.hu => peer0.org3.netbuild.hu
  - couchdb1.org3.netbuild.hu => peer1.org3.netbuild.hu
- 1 Setup / CLI container per organization (all containers 3)
  - cli.org1.netbuild.hu
  - cli.org2.netbuild.hu
  - cli.org3.netbuild.hu

All containers: 21

## Create consortium with 2 orgs

```bash
./generate-2org.sh
./start-2org-network.sh
./install-chaincode-2org.sh
```

## Create consortium with 3 orgs

```bash
./generate-3org.sh
./start-3org-network.sh
./install-chaincode-3org.sh
```
