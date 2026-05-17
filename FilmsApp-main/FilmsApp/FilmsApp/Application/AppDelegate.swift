import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       // Точка переопределения для настройки после запуска приложения
        return true
    }

    // Жизненный цикл UISceneSession

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Вызывается при создании новой сессии сцены.

        // Используйте этот метод для выбора конфигурации, с которой будет создана новая сцена.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Вызывается, когда пользователь закрывает сессию сцены.

         // Если какие-либо сессии были закрыты, пока приложение не работало, этот метод будет вызван вскоре после application:didFinishLaunchingWithOptions.

        // Используйте этот метод для освобождения ресурсов, специфичных для закрытых сцен, поскольку они не будут возвращены.
    }
}
