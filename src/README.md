# swissDAO smart contract

based on the ERC1155 standard

## v1

### Governance

- List of members (array of member addresses)
- Onboarding members
- Increasing points
- Activity points expiration mechanism
- Assigning guilds

### Membership

- each member has
  - experience points (ID 1)
  - activity points (ID 2)
  - attended events (ID 3)
  - assigned roles (AccessControl)
  - nickname, joinedAt, profileImageUri (STRUCT)
  - custom membership NFT (ID inherited from member address)

## Voting mechanism

Voting power of each member is proportional to their Level / Experience Points.
(A Level is directly calculated from experience points.)
