#!/bin/bash


while true
do
    #RANDOM_KEY="key-1"
    RANDOM_KEY="key-$(echo $RANDOM | md5sum | head -c 20)"
    RANDOM_VALUE="value-$(echo $RANDOM | md5sum | head -c 20)"
    echo "${RANDOM_KEY} => ${RANDOM_VALUE}"

    COMMAND="{\"function\":\"set\",\"args\":[\"${RANDOM_KEY}\",\"${RANDOM_VALUE}\"]}"

    RANDOM_ORG=$(( $RANDOM % 3 + 1 ))
    
    export CORE_PEER_LOCALMSPID=Org${RANDOM_ORG}MSP
    export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${RANDOM_ORG}.netbuild.hu/users/Admin@org${RANDOM_ORG}.netbuild.hu/msp
    # peer chaincode invoke -o orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA -C demochannel -n sacc \
    # --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE \
    # --peerAddresses peer1.org1.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer1.org1.netbuild.hu/tls/ca.crt \
    # --peerAddresses peer0.org2.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/ca.crt \
    # --peerAddresses peer1.org2.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer1.org2.netbuild.hu/tls/ca.crt \
    # --peerAddresses peer0.org3.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer0.org3.netbuild.hu/tls/ca.crt \
    # --peerAddresses peer1.org3.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer1.org3.netbuild.hu/tls/ca.crt \
    # -c $COMMAND --waitForEvent

    peer chaincode invoke -o orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA -C demochannel -n sacc \
    --peerAddresses peer0.org1.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.netbuild.hu/peers/peer0.org1.netbuild.hu/tls/ca.crt \
    --peerAddresses peer0.org2.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/ca.crt \
    --peerAddresses peer0.org3.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.netbuild.hu/peers/peer0.org3.netbuild.hu/tls/ca.crt \
    -c $COMMAND
    #-c $COMMAND --waitForEvent


    # peer chaincode invoke -o orderer.netbuild.hu:7050 --tls --cafile $ORDERER_TLS_CA -C demochannel -n sacc \
    # --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE \
    # --peerAddresses peer0.org2.netbuild.hu:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.netbuild.hu/peers/peer0.org2.netbuild.hu/tls/ca.crt \
    # -c $COMMAND --waitForEvent

    sleep $((1 / $((($RANDOM % 50) + 1))))

done