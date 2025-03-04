//
//  README.MD
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/21/25.
//

# Hero Coach 🧢 | 🍎 Swift Student Challenge 2025 Submission
### A goals experience for you

## Quick Demo: https://www.youtube.com/watch?v=A0phG_YCdII

## The problem
Hero Coach explores the stress and anxiety when a person has too much on their plate. Hero Coach aims to alleviate this by allowing users to organize their thoughts and provide tailored advice to help achieve their goals. Through using this app, you become your own hero.

## Why, How, and What
I was inspired to build Hero Coach by the challenges I faced last summer while trying to lose weight. Going into the summer I was at an unhealthy weight that I wanted to lose it, but I was overwhelmed with an overload of information online. Including caloric deficits, protein intake, cardio, and weightlifting. I struggled to stay consistent. However, I found light at the end of the tunnel by taking it one day at a time. I took the approach of setting realistic, achievable goals. This relieved a lot of my stress and built momentum through small wins. This is what Hero Coach aims to solve, organize your goals and make them achievable.

This app is designed for users who feel overwhelmed by many goals, Hero Coach takes a person’s aspirations and transforms them into actionable steps. Built using MVVM architecture, it leverages SwiftUI, SwiftData, CreateML, CoreML, NaturalLanguage, Speech, AVFoundation, and PhotosUI.

Hero Coach welcomes users to a modern start-up animation and a mesh gradient inspired by Apple Intelligence. During onboarding, users input their name, traits that motivate them, and an optional role model, leading to a personalized coach that provides tailored advice throughout the app.

The user lands in the app being presented with a quote of the day and paths to select from once a goal is created. To create a new goal, users tap on the plus button to either manually create a new goal, talk to coach, or type to coach. Manually adding a goal allows users to upload images, which are displayed in a horizontal parallax effect. On creation goals are automatically classified into a path, for example “I want to lose weight” = Health/Fitness. I achieved this through training a text classification model on a goals dataset in CreateML. This helps users organize and track progress efficiently.
The ”Talk to Coach” and “Type to Coach” feature uses Apple’s Speech framework and Natural Language to extract goals from spoken or typed input. If a user feels overwhelmed, they can speak/type their thoughts, and Hero Coach will generate actionable goals with mini-goals and deadlines. This makes setting goals more natural and stress-free.

Each goal belongs to a themed path, hero users can view progress through mini-goal completion, pin goals, and search goals. Tapping on a goal reveals tailored information including photos, personalized coaching advice, a progress tracker, and a section for managing your mini-goals. Completing a goal reveals a celebratory modal, storing reflections in the Book tab.

Next, the journey and profile tabs introduces gamification to encourage users to stay on track. Users rank up and share progress using ShareLink. When a user reaches Hero rank the reflections the user wrote are displayed in relevant goals to help users learn from past experiences and stay motivated.

Hero Coach is more than a goal tracker, it’s a personal growth experience. By providing tailored coaching, actionable goal-setting, and meaningful reflections, the app empowers users to take control of their aspirations and become their own hero.

## Beyond
I would like to thank anyone and everyone for this opportunity to bring my idea to life. I initially thought of this app idea my freshman year, but I couldn’t find the right place to apply it until now. The idea was originally a medication-tracking app but with a twist. It will help people take their medication using positive reinforcement. The goal is to relieve any negative feelings that come with taking medication to ultimately help the person to the finish line, 100%. This idea originated from my personal experience of having difficulty taking medication. However, this challenge helped me realize that life is all about perspective, everyone has their challenges. I want to make a goals app that includes all aspects of life, and I believe I’ve done that.

One side note I wanted to mention is that the requirement of the app not relying on a network connection really made me think outside of the box. The Apple Developer app on macOS was a lifesaver since I had no experience using an ML model, natural language, etc. This app would not have been possible without those video tutorials. I hope you enjoy my app experience, Hero Coach!

