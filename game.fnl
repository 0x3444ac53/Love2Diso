(local love (require :love))
(local repl (require "lib.stdio"))
(local sti (require :lib.sti))
(set _G.keys {})
(set _G.player
     {:pos {:x 400 :y 300}
      :update
      (fn [self dt]
        (each [k _ (pairs _G.keys)]
          (when (. self.keyHandlers k)
            ((. self.keyHandlers k) self dt)))
        self)
      :keyHandlers {:w (fn [self dt] (set self.pos.y (- self.pos.y (* dt 100))))
                    :a (fn [self dt] (set self.pos.x (- self.pos.x (* dt 100))))
                    :s (fn [self dt] (set self.pos.y (+ self.pos.y (* dt 100))))
                    :d (fn [self dt] (set self.pos.x (+ self.pos.x (* dt 100))))}})
       

(fn love.keypressed [key]
  (tset _G.keys key true)
  (love.graphics.print key 100 100))

(fn love.keyreleased [k s]
  (tset _G.keys k nil))

(fn load-char-sprite [type]
  (local quads {})
  (local dirs [
               :up
               :right_up
               :right
               :right_down
               :down
               :left_down 
               :left 
               :left_up])
  (local y_chord 24)
  (local image (love.graphics.newImage "assets/char.png"))
  (for [i 1 8]
    (tset quads
          (. dirs i) 
          [(love.graphics.newQuad (* i 16) y_chord 16 24 image)
           (love.graphics.newQuad (* i 16) (* y_chord 2) 16 24 image)
           (love.graphics.newQuad (* i 16) (* y_chord 3) 16 24 image)]))
  {:char-sprite quads
   :image image})

(fn love.load []
  (love.window.setMode 800 600)
  (love.graphics.setColor 1 1 1)
  (repl.start)
  (let [{: char-sprite : image} (load-char-sprite "deafult")]
   (set _G.player.sprite char-sprite)
   (set _G.player.spritesheet image))
  (set _G.map (sti :assets/t.lua)))

(fn love.update [dt]
  (_G.map:update dt)
  (_G.player:update dt))

(fn love.draw []
  (_G.map:draw)
  (var i 100)
  (each [k v (pairs _G.keys)] 
    (love.graphics.print k i 100)
    (set i (+ 100 i)))
  (_G.player:draw))
