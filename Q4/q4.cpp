// Question

/*
// Q4 - Assume all method calls work fine. Fix the memory leak issue in below method
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
*/

// Solution

/*
First, I attempted an approach using smart pointers in C++. Then, I realized that the player and the item are stored globally. 
When I was evaluating the TFS source code, I decided to stick with raw pointers, deleting them only when they are not found, to free up the allocated memory. 
This solution is implemented and working in the compilation provided along with the trial
*/
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
	// Get the recipient player
	Player* player = g_game.getPlayerByName(recipient);

	// Check if the player were found
	if (!player)
	{
		player = new Player(nullptr);

		// Attempt to fetch it from the database.
		if (!IOLoginData::loadPlayerByName(player, recipient))
		{
			// If the player is still not found, finish the method call
			delete player;
			return;
		}
	}

	// Create an item instance
	Item* item = Item::CreateItem(itemId);

	if (!item) {
		// If the item was not created, finish the method call.
		delete item;
		return;
	}

	// Try yo add the item to the player (Added some validation).
	ReturnValue result = g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
	if (result != RETURNVALUE_NOERROR)
	{
		// If the internalAddItem call returned any error code, finish the method call
		delete item;
		return;
	}

	// Save the player if it's offline
	if (player->isOffline()) {
		IOLoginData::savePlayer(player);
		delete player;
	}
}