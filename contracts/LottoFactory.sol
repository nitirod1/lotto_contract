// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "./LottoToken.sol";

contract LottoFactory {
    uint256 MAX_NUMBER = 1000000;
    uint256 MIN_NUMBER = 99999;
    address ADMIN ;
    address CONTROLLER ;
    uint256 installment = 0;

    LottoToken lottoToken ;
     // address to installment to number
    mapping(address =>  mapping(uint256 => uint256[])) walletLotto;
    // address to installment to number mapping to tokenId
    mapping (address => mapping(uint256 => mapping(uint256 => uint256))) walletTokenId;
   
    // Installment to MAX_NUMBER reward
    mapping(uint256 => uint256[]) reward1;
    mapping(uint256 => uint256[]) reward2;
    mapping(uint256 => uint256[]) reward3;
    mapping(uint256 => uint256[]) reward4;
    mapping(uint256 => uint256[]) reward5;

    constructor(){
        ADMIN = msg.sender;
        CONTROLLER = msg.sender;
    }
    
    event BuyLotto(address user, uint256 balance);
    
    modifier IsAdmin(){
        require(msg.sender == ADMIN);
        _;
    }

    modifier IsController(){
        require(msg.sender == ADMIN || msg.sender == CONTROLLER);
        _;
    }

    function setController(address _controller)external IsAdmin(){
        CONTROLLER = _controller;
    }

    function setLottoAddress(address _address) external IsAdmin(){
        lottoToken = LottoToken(_address);
    }

    function getInstallment()public view returns(uint256){
        return installment;
    }

    function nextInstallment()external IsController(){
        installment = installment +1;
    }

    function getReward(uint256 _installment)public view returns(uint256[] memory, uint256 []memory,uint256 []memory,uint256 []memory,uint256 []memory){
        return (reward1[_installment],reward2[_installment],reward3[_installment],reward4[_installment],reward5[_installment]);
    }
    // get my token id
    function getWalletLotto(address _owner,uint256 _installment)public view returns(uint256[]memory){
        return walletLotto[_owner][_installment];
    }

    function getWalletTokenId(address _owner , uint256 _installment,uint256 _number)public view returns(uint256){
        return walletTokenId[_owner][_installment][_number];
    }

    function ranReward1()external IsController(){
        uint256 rand = block.prevrandao ;
        uint256[1] memory temp ;
        for(uint256 i=0;i<1;i++){
            uint256 reward = uint256(keccak256(abi.encodePacked(block.timestamp,rand,msg.sender))) % MAX_NUMBER;
            if(reward < MIN_NUMBER){
                reward = reward *10;
            }
            temp[i] = reward;
            rand++;
        }
        reward1[installment] = temp;
    }
    
    function ranReward2()external IsController(){
        uint256 rand = block.prevrandao ;
        uint256[5] memory temp ;
        for(uint256 i=0;i<5;i++){
            uint256 reward = uint256(keccak256(abi.encodePacked(block.timestamp,rand,msg.sender))) % MAX_NUMBER;
            if(reward < MIN_NUMBER){
                reward = reward *10;
            }
            temp[i] = reward;
            rand++;
        }
        reward2[installment] = temp;
    }

    function ranReward3()external IsController(){
        uint256 rand = block.prevrandao ;
        uint256[10] memory temp ;
        for(uint256 i=0;i<10;i++){
            uint256 reward = uint256(keccak256(abi.encodePacked(block.timestamp,rand,msg.sender))) % MAX_NUMBER;
            if(reward < MIN_NUMBER){
                reward = reward *10;
            }
            temp[i] = reward;
            rand++;
        }
        reward3[installment] = temp;
    }

    function ranReward4()external IsController(){
         uint256 rand = block.prevrandao ;
         uint256[50] memory temp ;
        for(uint256 i=0;i<50;i++){
            uint256 reward = uint256(keccak256(abi.encodePacked(block.timestamp,rand,msg.sender))) % MAX_NUMBER;
            if(reward < MIN_NUMBER){
                reward = reward *10;
            }
            temp[i] = reward;
            rand++;
        }
        reward4[installment] = temp;
    }

    function ranReward5()external IsController(){
         uint256 rand = block.prevrandao ;
         uint256[100] memory temp ;
        for(uint256 i=0;i<100;i++){
           uint256 reward = uint256(keccak256(abi.encodePacked(block.timestamp,rand,msg.sender))) % MAX_NUMBER;
           if(reward < MIN_NUMBER){
                reward = reward *10;
            }
            temp[i] = reward;
            rand++;
        }
        reward5[installment] = temp;
    }

    function buyLotto(address _buyer, uint256 _number , string memory _uri) external payable {
        require(msg.value >=1000000 gwei);
        require(MAX_NUMBER >_number && MIN_NUMBER <_number);
        uint256 tokenId = lottoToken.safeMint(_buyer, _uri);
        walletLotto[_buyer][installment].push(_number);
        walletTokenId[_buyer][installment][_number] = tokenId;
    }

    function checkReward(address _owner,uint256 _installment,uint256 _number)public view returns(string memory){
        uint256 tokenId = walletTokenId[_owner][_installment][_number] ;
        if(lottoToken.ownerOf(tokenId) == _owner) {
            if (_number == reward1[_installment][0]){
                return "1";
            }
            for(uint256 i =0;i<reward2[_installment].length;i++){
                if (_number == reward2[_installment][i]){
                    return"2";
                }
            }
            for(uint256 i =0;i<reward3[_installment].length;i++){
                if (_number == reward3[_installment][i]){
                    return "3";
                }
            }
            for(uint256 i =0;i<reward4[_installment].length;i++){
                if (_number == reward4[_installment][i]){
                    return "4";
                }
            }
            for(uint256 i =0;i<reward5[_installment].length;i++){
                if (_number == reward5[_installment][i]){
                    return "5";
                }
            }
            return "0";
        }else{
            return "not owner";
        }
    }

    receive() external payable {
        emit BuyLotto(msg.sender, msg.value);
    }
}
