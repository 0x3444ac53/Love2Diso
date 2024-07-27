(local love (require :love))
(local repl (require "lib.stdio"))

(global tileset (love.graphics.newImage "assets/spritesheet.png"))
(global tiles {})


(fn nil? [v] (= nil v))

(fn loadTile [ID]
  (tset tiles ID
        (let [sy (* 32 (math.floor (/ ID 10)))
              sx (* 32 (% ID 11))]
          (love.graphics.newQuad sx sy 32 32 tileset)))
  (. tiles ID))

(fn drawTile [ID x y]
  (let [tile (or (. tiles ID) (loadTile ID))]
   (love.graphics.draw tileset
                       tile
                       (#(* (- x y) 16)) 
                       (#(* (+ x y) 8)))))


(fn love.load []
  (love.window.setMode 800 600)
  (let [canvas  (love.graphics.newCanvas 10000 10000)]
    (love.graphics.setCanvas canvas)
    (love.graphics.clear)
    (let [m (love.filesystem.read "untitled.csv")]
      (var x 0)
      (var y -1)
      (each [k v (string.gmatch m "([^\n]*)\n?")]
        (set y (+ y 1))
        (set x 0)
        (each [k1 v1 (string.gmatch k "([^,]+)")]
          (when (~= k1 "-1") (drawTile k1 x y))
          (set x (+ x 1)))))
   (love.graphics.setCanvas nil)
   (set _G.canvas canvas))
  (repl.start))

(fn love.update [dt])

(fn love.draw []
  (love.graphics.draw _G.canvas 128 0))
