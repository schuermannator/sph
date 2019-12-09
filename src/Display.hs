module Display (display, idle) where
import Solver (update)
import Lib
import Graphics.UI.GLUT
import Data.IORef

drawPoints :: [(Float, Float)] -> IO ()
drawPoints ps = do
  let color3f r g b = color $ Color3 r g (b :: GLfloat)
      vertex3f x' y' z = vertex $ Vertex3 x' y' (z :: GLfloat)
  clear [ColorBuffer]
  loadIdentity
  pointSize $= 10
  pointSmooth $= Enabled
  renderPrimitive Points $
    -- color3f 1 0 1
    mapM_ (\(x, y) -> vertex3f x y 0) ps
   
-- display :: IORef [(GLfloat, GLfloat)] -> DisplayCallback
display :: IORef [Particle] -> DisplayCallback
display ps = do
  ps' <- get ps
  drawPoints (getPoints ps') -- [(0+x', 0), (0.2+x', 0), (0.5+x', 0.5)]
  swapBuffers

getPoints :: [Particle] -> [(Float, Float)]
getPoints ps = map getPoint ps

getPoint :: Particle -> (Float, Float)
getPoint (Particle p _ _ _ _) = parse p
  where parse (GLPoint x y) = (x, y)
-- getPoint _ = (1.0, 1.0)
          
-- idle :: IORef [(GLfloat, GLfloat)] -> IdleCallback
idle :: IORef [Particle] -> IdleCallback
idle ps = do
  ps' <- get ps
  writeIORef ps (update ps')
  postRedisplay Nothing