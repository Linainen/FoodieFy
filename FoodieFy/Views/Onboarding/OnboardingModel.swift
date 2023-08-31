//
//  OnboardingModel.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 21.08.23.
//

import Foundation

struct OnboardingModel {
    static func setupContent() -> [OnboardingSlide] {
        let slides: [OnboardingSlide] = [
            OnboardingSlide(title: "Delicious Dishes", description: "Discover the unique dishes and learn how traditional Belarusian cuisine can be both delicious and healthy.", image: #imageLiteral(resourceName: "slide 1")),
            OnboardingSlide(title: "World-Class Chefs", description: "Our talented chefs bring their expertise and creativity to every dish they create. ", image: #imageLiteral(resourceName: "slide 3")),
            OnboardingSlide(title: "Instant Delivery", description: "High speed delivery at your doorstep provided by our professional couriers.", image: #imageLiteral(resourceName: "slide 2"))
        ]
        return slides
    }
}
