pragma solidity ^0.5.0;

contract PostContract {
    string public name;
    uint public postCount = 0; //keep count of total posts
    mapping(uint => Post) public posts; //mapped

    struct Post {
        uint id; //count
        string hash; //content id
        uint tipAmount; //tipamt till now
        address payable author; //to address
    }

    event PostCreated(
        uint id,
        string hash,
        uint tipAmount,
        address payable author
    );

    event PostTipped(
        uint id,
        string hash,
        uint tipAmount,
        address payable author
    );

    constructor() public {
        name = "Signed by Mir";
    }

    function createPost(string memory _hash) public {
        require(bytes(_hash).length > 0); 
        postCount ++; 
        posts[postCount] = Post(postCount, _hash, 0, msg.sender);
        emit PostCreated(postCount, _hash, 0, msg.sender);
    }

    function tipPost(uint _id) public payable {
        require(_id > 0 && _id <= postCount);
        Post memory _post = posts[_id];
        address payable _author = _post.author;
        address(_author).transfer(msg.value);
        _post.tipAmount = _post.tipAmount + msg.value;
        posts[_id] = _post;
        emit PostTipped(postCount, _post.hash, _post.tipAmount, _author);
    }
}
