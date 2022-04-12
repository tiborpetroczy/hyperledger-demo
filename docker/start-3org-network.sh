#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

set -ev

# Set env vars
export CHANNEL_NAME=demochannel

docker-compose -f docker-compose.yml down

docker-compose -f docker-compose.yml up -d ca.org1.netbuild.hu ca.org2.netbuild.hu ca.org3.netbuild.hu
docker-compose -f docker-compose.yml up -d orderer.netbuild.hu orderer2.netbuild.hu orderer3.netbuild.hu
docker-compose -f docker-compose.yml up -d couchdbOrg1Peer0 couchdbOrg1Peer1 peer0.org1.netbuild.hu peer1.org1.netbuild.hu
docker-compose -f docker-compose.yml up -d couchdbOrg2Peer0 couchdbOrg2Peer1 peer0.org2.netbuild.hu peer1.org2.netbuild.hu
docker-compose -f docker-compose.yml up -d couchdbOrg3Peer0 couchdbOrg3Peer1 peer0.org3.netbuild.hu peer1.org3.netbuild.hu
docker-compose -f docker-compose.yml up -d cli prometheus grafana fluentd
docker-compose -f docker-compose.yml up -d explorerdb
docker-compose -f docker-compose.yml up -d explorer
docker-compose -f docker-compose.yml up -d explorer

sleep 5
# Wait for Hyperledger Fabric to start
# In case of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=2
sleep ${FABRIC_START_TIMEOUT}

# Create the application channel
ORDERER_TLS_CA=`docker exec cli  env | grep ORDERER_TLS_CA | cut -d'=' -f2`
docker exec cli peer channel create -o orderer.netbuild.hu:7050 -c $CHANNEL_NAME -f /etc/hyperledger/configtx/$CHANNEL_NAME.tx --tls --cafile $ORDERER_TLS_CA

# Join peer0.org1.netbuild.hu to the channel
docker exec cli peer channel join -b $CHANNEL_NAME.block

# Join peer1.org1.netbuild.hu.com to fetch channel block
docker exec -e CORE_PEER_ADDRESS=peer1.org1.netbuild.hu:7051 -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/server.crt -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/server.key -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/ca.crt cli peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA

# Join peer1.org1.netbuild.hu.com to the channel
docker exec -e CORE_PEER_ADDRESS=peer1.org1.netbuild.hu:7051 -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/server.crt -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/server.key -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/ca.crt cli peer channel join -b $CHANNEL_NAME.block

# Join peer0.org2.netbuild.hu to the channel
docker exec -e CORE_PEER_LOCALMSPID=Org2MSP -e CORE_PEER_ADDRESS=peer0.org2.netbuild.hu:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/users/Admin@org2.netbuild.hu/msp \
    cli peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA

docker exec -e CORE_PEER_LOCALMSPID=Org2MSP -e CORE_PEER_ADDRESS=peer0.org2.netbuild.hu:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/users/Admin@org2.netbuild.hu/msp \
    cli peer channel join -b $CHANNEL_NAME.block

# Join peer1.org2.netbuild.hu to the channel
docker exec -e CORE_PEER_LOCALMSPID=Org2MSP -e CORE_PEER_ADDRESS=peer1.org2.netbuild.hu:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer1.org2.netbuild.hu/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer1.org2.netbuild.hu/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer1.org2.netbuild.hu/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/users/Admin@org2.netbuild.hu/msp \
    cli peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA

docker exec -e CORE_PEER_LOCALMSPID=Org2MSP -e CORE_PEER_ADDRESS=peer1.org2.netbuild.hu:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer1.org2.netbuild.hu/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer1.org2.netbuild.hu/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer1.org2.netbuild.hu/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/users/Admin@org2.netbuild.hu/msp \
    cli peer channel join -b $CHANNEL_NAME.block

# Join peer0.org3.netbuild.hu to the channel
docker exec -e CORE_PEER_LOCALMSPID=Org3MSP -e CORE_PEER_ADDRESS=peer0.org3.netbuild.hu:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer0.org3.netbuild.hu/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer0.org3.netbuild.hu/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer0.org3.netbuild.hu/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/users/Admin@org3.netbuild.hu/msp \
    cli peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA

docker exec -e CORE_PEER_LOCALMSPID=Org3MSP -e CORE_PEER_ADDRESS=peer0.org3.netbuild.hu:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer0.org3.netbuild.hu/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer0.org3.netbuild.hu/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer0.org3.netbuild.hu/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/users/Admin@org3.netbuild.hu/msp \
    cli peer channel join -b $CHANNEL_NAME.block

# Join peer1.org3.netbuild.hu to the channel
docker exec -e CORE_PEER_LOCALMSPID=Org3MSP -e CORE_PEER_ADDRESS=peer1.org3.netbuild.hu:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer1.org3.netbuild.hu/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer1.org3.netbuild.hu/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer1.org3.netbuild.hu/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/users/Admin@org3.netbuild.hu/msp \
    cli peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA

docker exec -e CORE_PEER_LOCALMSPID=Org3MSP -e CORE_PEER_ADDRESS=peer1.org3.netbuild.hu:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer1.org3.netbuild.hu/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer1.org3.netbuild.hu/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer1.org3.netbuild.hu/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/users/Admin@org3.netbuild.hu/msp \
    cli peer channel join -b $CHANNEL_NAME.block

# Anchor peer - peer1.org1.netbuild.hu
docker exec -e CORE_PEER_ADDRESS=peer1.org1.netbuild.hu:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/ca.crt \
    cli peer channel update -o orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA -c $CHANNEL_NAME -f /etc/hyperledger/configtx/Org1MSPanchors.tx 
    
# Anchor peer - peer1.org2.netbuild.hu
docker exec -e CORE_PEER_LOCALMSPID=Org2MSP -e CORE_PEER_ADDRESS=peer1.org2.netbuild.hu:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer1.org2.netbuild.hu/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer1.org2.netbuild.hu/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer1.org2.netbuild.hu/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/users/Admin@org2.netbuild.hu/msp \
    cli peer channel update -o orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA -c $CHANNEL_NAME -f /etc/hyperledger/configtx/Org2MSPanchors.tx 

# Anchor peer - peer1.org3.netbuild.hu
docker exec -e CORE_PEER_LOCALMSPID=Org3MSP -e CORE_PEER_ADDRESS=peer1.org3.netbuild.hu:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer1.org3.netbuild.hu/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer1.org3.netbuild.hu/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer1.org3.netbuild.hu/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/users/Admin@org3.netbuild.hu/msp \
    cli peer channel update -o orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA -c $CHANNEL_NAME -f /etc/hyperledger/configtx/Org3MSPanchors.tx 
