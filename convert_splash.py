#!/usr/bin/env python3
"""
SVG'yi PNG'ye çeviren script
Gerekli: pip install cairosvg pillow
"""

try:
    import cairosvg
    import os
    
    # SVG dosyasını PNG'ye çevir
    input_file = "assets/splash/splash.svg"
    output_file = "assets/splash/splash.png"
    
    if os.path.exists(input_file):
        # SVG'yi PNG'ye çevir
        cairosvg.svg2png(
            url=input_file,
            write_to=output_file,
            output_width=1080,
            output_height=1920
        )
        print(f"✅ {input_file} -> {output_file} başarıyla çevrildi!")
        
        # SVG dosyasını sil
        os.remove(input_file)
        print("🗑️ SVG dosyası silindi")
        
    else:
        print(f"❌ {input_file} bulunamadı!")
        
except ImportError:
    print("❌ cairosvg kütüphanesi bulunamadı!")
    print("Kurulum için: pip install cairosvg")
    
    # Alternatif olarak basit bir PNG oluştur
    try:
        from PIL import Image, ImageDraw, ImageFont
        
        # 1080x1920 boyutunda gradient PNG oluştur
        img = Image.new('RGB', (1080, 1920), color='#1a1a2e')
        draw = ImageDraw.Draw(img)
        
        # Basit gradient efekti
        for y in range(1920):
            # Y ekseninde gradient
            r = int(26 + (y / 1920) * 20)  # 26 -> 46
            g = int(26 + (y / 1920) * 30)  # 26 -> 56
            b = int(46 + (y / 1920) * 40)  # 46 -> 86
            color = (r, g, b)
            
            # Yatay çizgi çiz
            draw.line([(0, y), (1080, y)], fill=color)
        
        # Logo alanı için beyaz daire
        center_x, center_y = 540, 960
        logo_radius = 120
        
        # Logo arkaplanı
        draw.ellipse([
            center_x - logo_radius, 
            center_y - logo_radius,
            center_x + logo_radius, 
            center_y + logo_radius
        ], fill=(255, 255, 255, 25))
        
        # Film ikonu (basit)
        icon_size = 80
        icon_x = center_x - icon_size // 2
        icon_y = center_y - icon_size // 2
        
        # Film strip
        draw.rounded_rectangle([
            icon_x, icon_y, 
            icon_x + icon_size, icon_y + icon_size
        ], radius=8, fill=(255, 255, 255, 230))
        
        # Film delikleri
        hole_radius = 4
        holes = [
            (icon_x + 20, icon_y + 20),
            (icon_x + 60, icon_y + 20),
            (icon_x + 20, icon_y + 60),
            (icon_x + 60, icon_y + 60)
        ]
        
        for hole_x, hole_y in holes:
            draw.ellipse([
                hole_x - hole_radius, hole_y - hole_radius,
                hole_x + hole_radius, hole_y + hole_radius
            ], fill='#1a1a2e')
        
        # Play button
        play_points = [
            (icon_x + 32, icon_y + 25),
            (icon_x + 32, icon_y + 55),
            (icon_x + 52, icon_y + 40)
        ]
        draw.polygon(play_points, fill='#e94560')
        
        # App name
        try:
            font = ImageFont.truetype("arial.ttf", 32)
        except:
            font = ImageFont.load_default()
            
        draw.text((center_x, center_y + 180), "REPLIK", 
                  fill='white', font=font, anchor="mm")
        
        # Tagline
        try:
            small_font = ImageFont.truetype("arial.ttf", 16)
        except:
            small_font = ImageFont.load_default()
            
        draw.text((center_x, center_y + 210), "Movie Explorer", 
                  fill=(255, 255, 255, 180), font=small_font, anchor="mm")
        
        # Kaydet
        img.save(output_file, "PNG")
        print(f"✅ Basit PNG splash ekranı oluşturuldu: {output_file}")
        
    except ImportError:
        print("❌ PIL kütüphanesi de bulunamadı!")
        print("Kurulum için: pip install pillow")
        print("Manuel olarak PNG dosyası oluşturmanız gerekiyor.")
