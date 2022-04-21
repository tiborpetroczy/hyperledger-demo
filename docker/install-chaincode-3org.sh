#!/bin/bash

#env | grep -i core | sort
#### PEER0.ORG1
CORE_PEER_ADDRESS=peer0.org1.netbuild.hu:7051
CORE_PEER_LOCALMSPID=Org1MSP
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/users/Admin@org1.netbuild.hu/msp
CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer0.org1.netbuild.hu/tls/server.crt
CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer0.org1.netbuild.hu/tls/server.key
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer0.org1.netbuild.hu/tls/ca.crt


docker exec -w /opt/gopath/src/github.com/chaincode/sacc cli bash -c "GO111MODULE=on go mod vendor"
docker exec -w /root cli bash -c "peer lifecycle chaincode package sacc.tar.gz --path /opt/gopath/src/github.com/chaincode/sacc/ --lang golang --label sacc_1.0"
docker exec -w /root cli bash -c "peer lifecycle chaincode install sacc.tar.gz"
docker exec cli peer lifecycle chaincode queryinstalled

docker exec cli bash -c '
CC_PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | grep "Package ID" | cut -d"," -f1 | cut -d" " -f3);
peer lifecycle chaincode approveformyorg -o orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA --channelID demochannel --name sacc --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1'

docker exec cli bash -c '
CC_PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | grep "Package ID" | cut -d"," -f1 | cut -d" " -f3);
peer lifecycle chaincode approveformyorg -o orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA --channelID demochannel --name sacc --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1
'

docker exec -e CORE_PEER_ADDRESS=peer0.org2.netbuild.hu:7051 \
-e CORE_PEER_LOCALMSPID=Org2MSP \
-e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/users/Admin@org2.netbuild.hu/msp \
-e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/server.crt \
-e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/server.key \
-e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/ca.crt \
-w /root \
cli bash -c '
peer lifecycle chaincode install sacc.tar.gz;
peer lifecycle chaincode queryinstalled;
CC_PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | grep "Package ID" | cut -d"," -f1 | cut -d" " -f3);
peer lifecycle chaincode approveformyorg -o orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA --channelID demochannel --name sacc --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1
'

docker exec -e CORE_PEER_ADDRESS=peer0.org3.netbuild.hu:7051 \
-e CORE_PEER_LOCALMSPID=Org3MSP \
-e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/users/Admin@org3.netbuild.hu/msp \
-e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer0.org3.netbuild.hu/tls/server.crt \
-e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer0.org3.netbuild.hu/tls/server.key \
-e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer0.org3.netbuild.hu/tls/ca.crt \
-w /root cli bash -c '
peer lifecycle chaincode install sacc.tar.gz;
peer lifecycle chaincode queryinstalled;
CC_PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | grep "Package ID" | cut -d"," -f1 | cut -d" " -f3);
peer lifecycle chaincode approveformyorg -o orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA --channelID demochannel --name sacc --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1;
peer lifecycle chaincode checkcommitreadiness --channelID demochannel --name sacc --version 1.0 --sequence 1 --output json
'

docker exec -e CORE_PEER_ADDRESS=peer0.org1.netbuild.hu:7051 \
-e CORE_PEER_LOCALMSPID=Org1MSP \
-e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/users/Admin@org1.netbuild.hu/msp \
-e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer0.org1.netbuild.hu/tls/server.crt \
-e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer0.org1.netbuild.hu/tls/server.key \
-e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer0.org1.netbuild.hu/tls/ca.crt \
cli bash -c '
peer lifecycle chaincode commit -o orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA --channelID demochannel \
    --name sacc --version 1.0 --sequence 1 \
    --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE \
    --peerAddresses peer0.org2.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/ca.crt \
    --peerAddresses peer0.org3.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer0.org3.netbuild.hu/tls/ca.crt;

peer lifecycle chaincode querycommitted --channelID demochannel --name sacc
'

docker exec -e CORE_PEER_ADDRESS=peer1.org1.netbuild.hu:7051 \
-e CORE_PEER_LOCALMSPID=Org1MSP \
-e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/users/Admin@org1.netbuild.hu/msp \
-e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/server.crt \
-e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/server.key \
-e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/ca.crt \
-w /root cli bash -c '
    peer lifecycle chaincode install sacc.tar.gz;
    peer lifecycle chaincode queryinstalled;
'

docker exec -e CORE_PEER_ADDRESS=peer1.org2.netbuild.hu:7051 \
-e CORE_PEER_LOCALMSPID=Org2MSP \
-e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/users/Admin@org2.netbuild.hu/msp \
-e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer1.org2.netbuild.hu/tls/server.crt \
-e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer1.org2.netbuild.hu/tls/server.key \
-e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer1.org2.netbuild.hu/tls/ca.crt \
-w /root cli bash -c '
    peer lifecycle chaincode install sacc.tar.gz;
    peer lifecycle chaincode queryinstalled
'

docker exec -e CORE_PEER_ADDRESS=peer1.org3.netbuild.hu:7051 \
-e CORE_PEER_LOCALMSPID=Org3MSP \
-e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/users/Admin@org3.netbuild.hu/msp \
-e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer1.org3.netbuild.hu/tls/server.crt \
-e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer1.org3.netbuild.hu/tls/server.key \
-e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer1.org3.netbuild.hu/tls/ca.crt \
-w /root cli bash -c '
    peer lifecycle chaincode install sacc.tar.gz;
    peer lifecycle chaincode queryinstalled
'

sleep 30

docker exec cli bash -c '
peer chaincode invoke -o orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA --channelID demochannel --name sacc \
--peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE \
--peerAddresses peer1.org1.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/ca.crt \
--peerAddresses peer0.org2.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/ca.crt \
--peerAddresses peer1.org2.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer1.org2.netbuild.hu/tls/ca.crt \
--peerAddresses peer0.org3.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer0.org3.netbuild.hu/tls/ca.crt \
--peerAddresses peer1.org3.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer1.org3.netbuild.hu/tls/ca.crt \
-c "{\"function\":\"set\",\"args\":[\"key1\",\"$RANDOM\"]}" --waitForEvent
'

# SAMPLE QUERY 
# docker exec cli bash -c '
# peer chaincode query --channelID demochannel --name sacc \
# --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE \
# -c "{\"function\":\"get\",\"args\":[\"key1\"]}"
# '

# SAMPLE INVOKE
# peer chaincode invoke -o orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA -C demochannel -n sacc \
# --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE \
# --peerAddresses peer1.org1.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/ca.crt \
# --peerAddresses peer0.org2.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/ca.crt \
# -c '{"function":"set","args":["car1","merci"]}' --waitForEvent
