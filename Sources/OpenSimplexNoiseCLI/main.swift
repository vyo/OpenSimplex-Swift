let tool = CLI()

do {
    try tool.run()
} catch {
    print("Whoops! An error occurred: \(error)")
}
