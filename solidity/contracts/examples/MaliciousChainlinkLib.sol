pragma solidity 0.4.24;

import "solidity-cborutils/contracts/CBOR.sol";

library MaliciousChainlinkLib {
  uint256 internal constant defaultBufferSize = 256;

  using CBOR for Buffer.buffer;

  struct Run {
    bytes32 specId;
    bytes4 callbackFunctionId;
    bytes32 requestId;
    Buffer.buffer buf;
  }

  struct WithdrawRun {
    bytes32 specId;
    bytes4 callbackFunctionId;
    bytes32 requestId;
    uint256 amount;
    Buffer.buffer buf;
  }

  function initialize(
    Run memory self,
    bytes32 _specId,
    bytes4 _callbackFunction
  ) internal pure returns (MaliciousChainlinkLib.Run memory) {
    Buffer.init(self.buf, defaultBufferSize);
    self.specId = _specId;
    self.callbackFunctionId = _callbackFunction;
    self.buf.startMap();
    return self;
  }

  function initializeWithdraw(
    WithdrawRun memory self,
    bytes32 _specId,
    bytes4 _callbackFunction
  ) internal pure returns (MaliciousChainlinkLib.WithdrawRun memory) {
    Buffer.init(self.buf, defaultBufferSize);
    self.specId = _specId;
    self.callbackFunctionId = _callbackFunction;
    self.buf.startMap();
    return self;
  }

  function add(Run memory self, string _key, string _value)
    internal pure
  {
    self.buf.encodeString(_key);
    self.buf.encodeString(_value);
  }

  function addBytes(Run memory self, string _key, bytes _value)
    internal pure
  {
    self.buf.encodeString(_key);
    self.buf.encodeBytes(_value);
  }

  function addInt(Run memory self, string _key, int256 _value)
    internal pure
  {
    self.buf.encodeString(_key);
    self.buf.encodeInt(_value);
  }

  function addUint(Run memory self, string _key, uint256 _value)
    internal pure
  {
    self.buf.encodeString(_key);
    self.buf.encodeUInt(_value);
  }

  function addStringArray(Run memory self, string _key, string[] memory _values)
    internal pure
  {
    self.buf.encodeString(_key);
    self.buf.startArray();
    for (uint256 i = 0; i < _values.length; i++) {
      self.buf.encodeString(_values[i]);
    }
    self.buf.endSequence();
  }

  function close(Run memory self) internal pure {
    self.buf.endSequence();
  }

  function closeWithdraw(WithdrawRun memory self) internal pure {
    self.buf.endSequence();
  }
}
