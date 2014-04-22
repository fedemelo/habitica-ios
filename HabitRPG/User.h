//
//  User.h
//  HabitRPG
//
//  Created by Phillip Thelen on 21/04/14.
//  Copyright (c) 2014 Phillip Thelen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Egg, Gear, Group, Quest, Reward, Tag, Task;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * costumeArmor;
@property (nonatomic, retain) NSString * costumeBack;
@property (nonatomic, retain) NSString * costumeHead;
@property (nonatomic, retain) NSString * costumeHeadAccessory;
@property (nonatomic, retain) NSString * costumeShield;
@property (nonatomic, retain) NSString * costumeWeapon;
@property (nonatomic, retain) NSString * currentMount;
@property (nonatomic, retain) NSString * currentPet;
@property (nonatomic, retain) NSNumber * dayStart;
@property (nonatomic, retain) NSString * equippedArmor;
@property (nonatomic, retain) NSString * equippedBack;
@property (nonatomic, retain) NSString * equippedHead;
@property (nonatomic, retain) NSString * equippedHeadAccessory;
@property (nonatomic, retain) NSString * equippedShield;
@property (nonatomic, retain) NSString * equippedWeapon;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSNumber * gold;
@property (nonatomic, retain) NSString * hairBangs;
@property (nonatomic, retain) NSString * hairBase;
@property (nonatomic, retain) NSString * hairBeard;
@property (nonatomic, retain) NSString * hairColor;
@property (nonatomic, retain) NSString * hairMustache;
@property (nonatomic, retain) NSString * hclass;
@property (nonatomic, retain) NSNumber * health;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * magic;
@property (nonatomic, retain) NSNumber * maxHealth;
@property (nonatomic, retain) NSNumber * maxMagic;
@property (nonatomic, retain) NSNumber * nextLevel;
@property (nonatomic) BOOL participateInQuest;
@property (nonatomic, retain) NSString * shirt;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * skin;
@property (nonatomic) Boolean sleep;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) NSSet *ownedEggs;
@property (nonatomic, retain) NSSet *ownedFood;
@property (nonatomic, retain) NSSet *ownedGear;
@property (nonatomic, retain) NSSet *ownedHatchingPotions;
@property (nonatomic, retain) NSSet *ownedQuests;
@property (nonatomic, retain) Group *party;
@property (nonatomic, retain) Reward *rewards;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(Group *)value;
- (void)removeGroupsObject:(Group *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

- (void)addOwnedEggsObject:(Egg *)value;
- (void)removeOwnedEggsObject:(Egg *)value;
- (void)addOwnedEggs:(NSSet *)values;
- (void)removeOwnedEggs:(NSSet *)values;

- (void)addOwnedFoodObject:(NSManagedObject *)value;
- (void)removeOwnedFoodObject:(NSManagedObject *)value;
- (void)addOwnedFood:(NSSet *)values;
- (void)removeOwnedFood:(NSSet *)values;

- (void)addOwnedGearObject:(Gear *)value;
- (void)removeOwnedGearObject:(Gear *)value;
- (void)addOwnedGear:(NSSet *)values;
- (void)removeOwnedGear:(NSSet *)values;

- (void)addOwnedHatchingPotionsObject:(NSManagedObject *)value;
- (void)removeOwnedHatchingPotionsObject:(NSManagedObject *)value;
- (void)addOwnedHatchingPotions:(NSSet *)values;
- (void)removeOwnedHatchingPotions:(NSSet *)values;

- (void)addOwnedQuestsObject:(Quest *)value;
- (void)removeOwnedQuestsObject:(Quest *)value;
- (void)addOwnedQuests:(NSSet *)values;
- (void)removeOwnedQuests:(NSSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

- (void)setAvatarOnImageView:(UIImageView*)imageView;
- (void)setAvatarOnImageView:(UIImageView*)imageView withPetMount:(BOOL)withPetMount;
@end
