// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Crowdfunding {

    struct Campaign {
        address owner;
        string title;
        string description;
        uint target;
        uint amountCollected;
        uint deadline;
        string image;
        address[] donators;
        uint[] donations;
    }

    mapping (uint => Campaign) public campaigns;

    uint public numberOfCampaigns = 0;

    function createCampaign(
        address _owner, 
        string memory _title, 
        string memory _description, 
        uint _target, 
        uint _amountCollected, 
        uint _deadline, 
        string memory _image
     ) 
     
        public returns (uint) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(campaign.deadline > block.timestamp, 
        "deadline must be in future"
        );

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.amountCollected = _amountCollected;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.image = _image;

        numberOfCampaigns++;
        return (numberOfCampaigns-1);
     }

    function donateToCampaign(uint _id) public payable {
        uint amount = msg.value; //msg.value means amount sending by the donators
        Campaign storage campaign = campaigns[_id];
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");
        if(sent){

            campaign.amountCollected=campaign.amountCollected + amount;
        }
    }

    function getDonators(uint _id) public view returns(address[] memory, uint[] memory){
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaign() public view returns(Campaign[] memory){
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);
        for(uint i=0; i < numberOfCampaigns ; i++){
        Campaign storage item = campaigns[i];
        allCampaigns[i] = item;
        }
        return allCampaigns;

    }



}
