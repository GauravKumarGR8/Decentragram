pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";

  // Store Images
  uint public imageCount = 0;
  mapping (uint => Images) public images;

  struct Images {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event imageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  event imageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  // Create Images
  function uploadImage(string memory _imgHash, string memory _description) public {
    // Make sure the image hash exists
    require(bytes(_imgHash).length > 0);

    // Make sure image description exists
    require(bytes(_description).length > 0);

    // Make sure uploader address exists
    require(msg.sender != address(0x0));

    // Increment Image id
    imageCount++ ;

    // Add Image to contract
    images[imageCount] = Images(imageCount, _imgHash, _description, 0, msg.sender);
    
    // Trigger an Event
    emit imageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  }

  // Tip Images
  function tipImageOwner(uint _id) public payable{
    // Make sure the id is valid
    require(_id > 0 && _id <= imageCount);

    // Fetch the Image
    Images memory _image = images[_id];

    // Fetch the author
    address payable _author = _image.author;

    // Pay the author by sending them ether
    address(_author).transfer(msg.value);

    // Increment the tip Amount
    _image.tipAmount += msg.value;

    // Update the image
    images[_id] = _image;

    // Trigger an Event
    emit imageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
  }
}



















