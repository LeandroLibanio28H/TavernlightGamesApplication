# Question

### Q4 - Assume all method calls work fine. Fix the memory leak issue in below method
```
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);
    if (!player) {
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }
}
```

## Considerations
First, I attempted an approach using smart pointers in C++. Then, I realized that the player and the item are stored globally. 
When I was evaluating the TFS source code, I decided to stick with raw pointers, deleting them only when they are not found, to free up the allocated memory.

This solution is implemented and working in the binaries sent along with the challenge. Just type /additemcustom, and your character will receive a free crystal coin.
