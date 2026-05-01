struct Achievement: Identifiable, Hashable {
    let id: Int
    let icon: String
    let title: String
    let description: String
    let requirement: AchievementRequirement
    var currentProgress: Int = 0
    var isUnlocked: Bool = false
}