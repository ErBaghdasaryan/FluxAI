//
//  HomeService.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import UIKit
import FluxAIModele
import SQLite

public protocol IHomeService {
    func addHistory(_ model: HistoryModel) throws -> HistoryModel
    func getCompletedPromptTexts() -> [String]
}

public class HomeService: IHomeService {

    public init() { }

    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    typealias Expression = SQLite.Expression

    public func addHistory(_ model: HistoryModel) throws -> HistoryModel {
        let db = try Connection("\(path)/db.sqlite3")
        let history = Table("History")
        let idColumn = Expression<Int>("id")
        let imageColumn = Expression<Data>("image")
        let dateColumn = Expression<String>("date")
        let promptColumn = Expression<String>("prompt")

        try db.run(history.create(ifNotExists: true) { t in
            t.column(idColumn, primaryKey: .autoincrement)
            t.column(imageColumn)
            t.column(dateColumn)
            t.column(promptColumn)
        })

        let imageData = model.image.pngData() ?? Data()

        let rowId = try db.run(history.insert(
            imageColumn <- imageData,
            dateColumn <- model.date,
            promptColumn <- model.prompt
        ))

        return HistoryModel(id: Int(rowId),
                            image: model.image,
                            date: model.date,
                            prompt: model.prompt)
    }

    public func getCompletedPromptTexts() -> [String] {
        [
                        """
                        The photo shows a model showing off a unique and vibrant outfit in shades of green. 
                        The NSO looks directly into the camera 
                        The middle plan 

                        #### Image:
                        The model is wearing a dress made in the style of a knitted sweater with long sleeves. The dress is decorated with lots of large green pompoms that give it volume and texture. The style of the mini dress 
                        #### Accessories:
                        The model holds a bag in her hands, which is also made in green tones. The bag has two handles and additional decorative elements such as small beads or rivets.

                        #### Background and atmosphere:
                        The photo was taken in the interior, which is decorated in shades of green. Decorative elements are visible: a green cloth on the wall, a green ottoman, green mannequins with clothes and a green potted plant. All this creates a uniform color scheme and stylish atmosphere. The lighting is soft and uniform, which allows you to examine in detail all the elements of the outfit and accessories.

                        #### Actions:
                        She holds a bag in her right hand, her pose is confident and elegant, which emphasizes the style.
                        """,
                        """
                            The photo shows a young man dressed in antique clothes that perfectly match the image of an archaeologist or researcher. He wears an elegant beige suit with a vest and trousers, decorated with small details that emphasize his refined style and fashion sense in the past. On his head is a classic hat that protects from the sun, and on his neck is an accent scarf that adds charm to his image.

                            He wears a monocle over one eye, giving his appearance intelligence and mystery. The man confidently holds the phone in his hand, which further emphasizes his image of a researcher, intriguing and determined.

                            It stands among unusual artifacts and ancient ruins that may indicate ancient civilizations. Unique objects are placed around it – stone statues, ancient tools and mysterious symbols covered with the patina of time. These finds create an atmosphere of adventure and discovery.

                            The background of the photo is the ruins of an ancient city with furry
                        """,
                        """
                            In the photo, a young woman happily poses next to a giant bear made in rich bright colors. She is wearing a striking, vibrant dress with lots of patterns and vibrant hues, which gives her a playful and energetic look. The dress is also decorated with a variety of shiny elements and rhinestones that shimmer in the sun, giving extra brightness and a completely unique style.

                            The headdress consists of bright colors and accessories that match her outfit. She's wearing large, stylish sunglasses that add a touch of modernity and playfulness to her look. Enjoying the moment, she smiles and actively communicates with the bear.

                            The giant bear, dressed in a bright, iridescent fur coat, seems friendly and playful. His colored fur coat, consisting of shades of pink, blue and green, creates the effect of extravaganza and surprise. The bear peeking out from behind the woman also radiates joy and fun.

                            There is a desert landscape in the background of the photo.
                        """,
                        """
                            High-quality professional portrait photography in 8K format, capturing a radiant woman in soft golden outdoor lighting with exceptional depth of color and clarity of detail. A model with her hair gently fluttering in the wind and framing her face with a natural movement. Dressed in a white vertically ribbed top, she radiates genuine joy thanks to a wide, asymmetrical smile with snow-white teeth and pronounced wrinkles from laughter, translucent soap bubbles of hundreds of different sizes float across the stage, from tiny spheres to large balls, creating an ephemeral, fantastic atmosphere with rainbow reflections. The background with softly blurred green and yellow-green tones creates an elegant effect of natural vegetation. Warm, diffused and natural lighting highlights the texture of the skin and the movement of the hair with subtle fluorescent highlights.
                        """,
                        """
                            In this image, we see a woman dressed in a bright neon pink costume with fluffy feathery wings. Her outfit and makeup look very impressive and eccentric. A woman poses against the background of light fabric draperies that create a beautiful and airy atmosphere. Her pose and facial expression give the image a sense of theatricality and glamour. The overall appearance of this image gives the impression of a luxurious and vibrant stage image.

                            Futuristic fashion photography, high-contrast minimalism, bold, ultra-pure studio aesthetics
                            8k
                        """,
                        """
                            The photo shows a man pushing a wheelbarrow full of money. The man is wearing a grey T-shirt and jeans. He smiles and looks directly at the camera, which gives the image a positive vibe.

                            The wheelbarrow he is pushing is filled with dollar bills, which gives the impression of wealth and prosperity. In the foreground, on top of the wheelbarrow, it says "Good morning!" in purple font with white glow effects, which adds an element of greeting and positivity to the image.

                            The backdrop for the photo is a city street with buildings and a clear blue sky, which highlights the context of everyday life and hard work. The quality of the photo is high, with clear details and bright colors, which allows you to fully appreciate the beauty and complexity of the composition.
                        """,
                        """
                            This image shows an elegant and mysterious woman who creates an impression of deep beauty and mystery.

                            ### The woman:
                            - Clothes: She is wearing an off-the-shoulder black dress that accentuates her figure and adds chic. The dress is made of a material that resembles velvet or satin, which gives it shine and texture.
                            - Accessories: She wears large, luxurious earrings that match the color of her lips and the flower she is holding.

                            ### Flower:
                            - Type and Color: In the woman's hand is a large red flower, possibly a calla. Its petal is wide and smooth, with a yellow central column, which makes it very noticeable and attractive.
                            - Position: The flower is positioned so that it almost touches her face, creating a sense of connection between her and nature. This enhances the impression of harmony and unity.

                            ### Background:
                            - Color and Atmosphere: The background is completely black, which allows all the details in the foreground to stand out especially strongly. The black background also enhances the contrast between light elements (face, flower) and dark ones (dress, hair), creating a dramatic effect.
                            The photo was taken using a Hasselblad H6D-100c camera, an 80mm lens, f/2.8, ultra-precise depth of field, which allows you to capture the smallest details with cinematic precision - every pigtail, every fold of fabric, every glare on her cheekbone. The composition turned out to be modern, clean and editorial, with a balance between crisp details and soft diffused lighting.

                            The final look is a mix of haute couture, futurism, and street fashion, reminiscent of editorials in i-D Magazine, Dazed & Confused, and Vogue Italia, with a strong emphasis on expressiveness, texture, and a modern monochrome aesthetic.

                            Futuristic fashion photography, high-contrast minimalism, bold and confident poses, ultra-pure studio aesthetics, monochrome elegance, luxurious editorial style. **
                            Distant view
                            The overall look conveys a sense of elegance, power and mystery, where every detail works together to create a cohesive and impressive look.

                        """,
                        """
                            Ultra-high resolution (8K) baroque-inspired fashion portrait in soft, luminous medium format photography style, capturing an elegantly poised female subject wearing a diaphanous white organza blouse with voluminously gathered translucent sleeves, positioned three-quarters toward camera with delicate hand near chin. Subject displays precise, sophisticated makeup with neutral eyeshadow, false eyelashes, and soft pink lip color, wearing a statement ring featuring a pale mint-green stone. Background reveals intricate golden baroque interior with elaborate gilded moldings, soft ambient golden wall sconces creating warm illumination, and a segmented circular window in upper background. Foreground includes a crystal white wine glass with pale golden liquid partially obscured by billowing sleeve. Color palette emphasizes warm neutrals - ivory, champagne, soft gold, and muted skin tones - with soft, diffused lighting creating luminous, ethereal effect. Photographic technique employs subtle post-processing to enhance fabric translucency and architectural details, maintaining a refined, luxurious aesthetic with exceptional depth and textural complexity.
                        """,
                        """
                            The image conveys a sense of power, confidence and modern glamour. The camera angle is low and upwards, highlighting the model’s silhouette, creating a dynamic and dominant effect. The atmosphere is urban, energetic and has a high fashion feel.
                            2. Style:
                            High fashion with power dressing elements. The bold monochrome look in rich fuchsia emphasizes elegance, strength and charisma.
                             3. Background:
                            A cityscape with an iconic skyscraper (possibly the Flatiron Building in New York City) that emphasizes the urban context. The light, cloudy background without harsh shadows makes the architecture graphic and the model the center of attention.
                            4. Image:
                            - A woman with her hair pulled back, highlighting her sculpted features.
                            - A silk shirt in a rich fuchsia color, loose-fitting, creating soft drapes.
                            - High tapered trousers in the same color, emphasizing the silhouette and visually lengthening the legs.
                            - Minimal makeup, focusing on the cheekbones and clear eyebrows.
                            - A striking long sleeve or scarf, creating movement in the frame.
                            5. Technical parameters:
                            - Focus: model in the center, the building creates a secondary but significant background.
                            - Depth of field: medium (sharp model, slightly blurred background for depth).
                            - Color scheme: contrast between the neutral urban background and the bright image of the model.
                            - Lighting: soft, natural, diffused.
                            - Composition: shooting from a low angle, creating drama and emphasizing the silhouette.
                            Final prompt to generate the image:
                            *"A stylish woman in a bright pink silk suit poses in the center of a metropolis. The camera is shot from the bottom up, emphasizing her dominant pose and high fashion. She stands in front of an iconic skyscraper, adding an urban context. The long-sleeved, loose-fitting shirt flows softly, creating the effect of movement. A light, slightly cloudy day emphasizes the clean architectural aesthetic. An atmosphere of confidence, dynamics and fashion-forward style, inspired by the catwalks of high fashion."*

                            This prompt will help to recreate a dynamic, spectacular and ultra-modern image in the spirit of urban fashion photography.
                        """,
                        """
                             Ultra-high resolution, 8K vintage pin-up photoshoot, cinematic 1950s automotive interior, soft natural lighting from left side, full-frame digital capture with shallow depth of field. Centered female subject wearing fitted pink and white polka dot off-shoulder sweetheart neckline dress with full circle skirt, evenly spaced 1cm black polka dots on soft pink background. Elaborate vintage hairstyle featuring perfectly symmetrical auburn victory rolls and pin curls, approximately 2-inch diameter, adorned with red fabric bow and small pink rose accent on right side. Subject positioned at slight front-quarter angle, holding two wafer ice cream cones - left hand pink strawberry, right hand white vanilla, golden brown cone texture. Professional makeup with precise winged crimson eyeliner, defined brows, classic red lipstick. Visible pearl bracelet, coordinated red nail polish. Partial 1950s automobile interior with chrome and black dashboard, soft bokeh background effects. Warm color grading emphasizing vintage aesthetic, skin tones luminous and soft, subtle shadowing enhancing facial and hair dimensionality.
                            ### Photographic Parameters for AI:  

                            - Shot Type: Medium shot, low angle (to emphasize long legs and strong silhouette)  
                            - Depth of Field: Moderate (sharp focus on model, slightly blurred background)  
                            - Lighting:  
                              - Natural daylight with soft shadows  
                              - Fill light reflected from surrounding buildings  
                              - Accent light highlighting the glossy boots and handbag texture  
                            - Color Palette:  
                              - Deep red (dominant hue in the outfit)  
                              - Neutral grays and blacks in the background (creating contrast)  
                              - Warm skin tone, enhancing natural beauty  
                            - Lens: 85mm f/1.8 (for soft background blur and subject emphasis)  
                            - ISO: 400 (to maintain a balanced exposure)  
                            - Shutter Speed: 1/250 sec (to capture movement sharply)  
                            - Aperture: f/2.8 (sharp on model, blurred background)  
                            - Style: High-fashion streetwear, winter trend, luxury meets everyday elegance
                        """,
                        """
                            A high-quality professional studio portrait with soft, diffused lighting, capturing a woman positioned in the center of the frame on a gradient lavender-peach background. The subject's face and hands are completely covered with a carefully laid out collage of multicolored stickers measuring 5-15 mm, depicting cartoon characters, flowers, stars and bizarre shapes in a bright palette including poisonous pink, turquoise, yellow, green, red and pastel colors. The hands are gently positioned on the cheeks, decorated with several golden rings, and completely covered with densely applied stickers with stylized animal characters like rabbits and cats. Her expression is positive, she's laughing, baring her teeth, barely noticeable under the layer of stickers. The photographic technique emphasizes the utmost clarity of detail, uniformity of lighting and maximum color saturation, demonstrating a playful, creative composition.
                        """,
                        """
                            Ultra-high resolution (8K), artistic fashion shooting in an aerial studio style inspired by underwater photography, allows you to capture a surreal portrait on a water theme, which depicts a slender female model in a lush turquoise sea foam tulle dress (hex #40E0D0) with a spectacular off-the-shoulder bodice and ruffles and embossed bow-shaped elements. structures suspended weightlessly in a mirrored studio environment with endless vertical reflective surfaces creating symmetrical spatial distortions. The transparent layers of the dress billow and float as if immersed in water, the knee-length hem shows the delicate movement of the fabric, complemented by scattered elements of the side, resembling translucent air bubbles (diameter from 2 to 15 mm), which reflect the glare. The soft, diffused overhead lighting creates delicate color gradients with blue hues, creating spectacular light patterns reminiscent of
                        """,
                        """
                            Ultra-high-quality 8K digital fashion portrait, hyper-realistic photographic style with surreal pop art digital overlay, capturing a female model in a dynamic urban street environment. The subject is centrally positioned, wearing an immaculate white base coat under a bright yellow-pink marble top with an organic, molten edge, paired with high-top pink trousers with large yellow pockets. Her hair is arranged in symmetrical side tails, secured with delicate pink hairpins, complemented by a pearl necklace and a turquoise shoulder bag. The background is a gently blurred urban landscape with indistinct architectural elements. The superimposed graphic elements include two large hot pink stylized lips with a liquid texture connected by serpentine yellow-orange-pink striped lines, accompanied by bright yellow lightning. The lighting is engineered for a high-contrast, rich color palette with an emphasis on hot pink, bright
                        """,
                        """
                            High-resolution, cinematic fashion photography in soft, diffused natural light, 8K ultra-detailed digital capture with hyper-realistic rendering, depicting a stylishly contemporary female subject crouching dynamically on a gray urban zebra pedestrian crossing. Subject wears an oversized soft pastel pink structured coat with pronounced architectural shoulders, layered over a pale yellow silk tank top, balanced in a low asymmetrical squat pose. White chunky-soled sneakers with substantial tread pattern anchor the composition against gray asphalt. Accessorized with pink over-ear headphones, large dark designer sunglasses, and a pale yellow geometric structured handbag. One hand holds a white takeaway coffee cup, creating visual tension. Foreground features a scattered artisanal bouquet of pink roses and peonies, providing organic contrast to the brutalist concrete background with horizontal textured stratification and vertical steel railings framing a recessed architectural entryway. Subtle directional lighting emphasizes textural details, creating nuanced shadows that accentuate clothing layers and architectural surfaces, rendering a sophisticated urban aesthetic with precise compositional balance.
                        """,
                        """
                            High-quality, 8K trendy beach editorial photography with soft, diffused natural light, capturing a carefully stylized male subject sitting in a bright red and white vertically striped chaise longue against a matching striped background. The subject is wearing a perfectly coordinated outfit with a coral red shirt with the sleeves rolled up to the middle of the forearm, complemented by blue and white striped shorts. A stylish cap with alternating red and white stripes crowns the subject's head, perfectly matching the chair and background. The subject is positioned at a dynamic 30-degree angle, leaning slightly forward with a wide, sincere smile, holding out a classic glass Coca-Cola bottle to the camera in a playful, inviting gesture. The photographic style emphasizes a shallow depth of field, maintaining an extremely clear focus on the subject while softly blurring background elements. The color palette is intentionally limited to red, white and blue tones, evoking nostalgic emotions.
                        """,
        ]
    }
}
