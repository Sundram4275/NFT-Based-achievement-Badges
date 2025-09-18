module MyModule::AchievementBadges {
    use aptos_framework::signer;
    use std::string::String;
    use std::vector;

    /// Struct representing an achievement badge NFT.
    struct Badge has store, key {
        name: String,           // Name of the achievement badge
        description: String,    // Description of the achievement
        rarity: u8,            // Rarity level (1-5, where 5 is rarest)
        earned_timestamp: u64,  // When the badge was earned
    }

    /// Struct to store all badges earned by a user.
    struct BadgeCollection has store, key {
        badges: vector<Badge>,  // Vector of all earned badges
        total_badges: u64,      // Total number of badges earned
    }

    /// Function to initialize a badge collection for a user.
    public fun initialize_collection(user: &signer) {
        let collection = BadgeCollection {
            badges: vector::empty<Badge>(),
            total_badges: 0,
        };
        move_to(user, collection);
    }

    /// Function to mint and award a new achievement badge to a user.
    public fun award_badge(
        admin: &signer,
        recipient: address,
        name: String,
        description: String,
        rarity: u8,
        timestamp: u64
    ) acquires BadgeCollection {
        // Create the new badge
        let badge = Badge {
            name,
            description,
            rarity,
            earned_timestamp: timestamp,
        };

        // Add badge to recipient's collection
        let collection = borrow_global_mut<BadgeCollection>(recipient);
        vector::push_back(&mut collection.badges, badge);
        collection.total_badges = collection.total_badges + 1;
    }
}