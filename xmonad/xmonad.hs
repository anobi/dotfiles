import XMonad

import XMonad.Prompt
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Prompt.AppendFile (appendFilePrompt)

import XMonad.Operations

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops

import XMonad.Layout.SimpleFloat
import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.IM
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Grid

import XMonad.Util.Run
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Dzen
import XMonad.Actions.Volume
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map as M

myXmonadBar = "dzen2 -x '1920' -y '0' -h '24' -w '960' -ta 'l' -fg '#FFFFFF' -bg '#1B1D1E'"
myStatusBar = "conky -c conf/conky_dzen | dzen2 -x '2880' -w '960' -h '24' -ta 'r' -bg '#1B1D1E' -fg '#FFFFFF' -y '0'"

main = do
    dzenLeftBar <- spawnPipe myXmonadBar
    dzenRightBar <- spawnPipe myStatusBar
    xmonad $ withUrgencyHookC dzenUrgencyHook { args = ["-bg", "red", "fg", "black", "-xs", "1", "-y", "25"]} urgencyConfig { remindWhen = Every 15 } $ defaultConfig 
        { modMask       = mod4Mask
        , terminal      = "urxvt"
        , workspaces    = myWorkspaces
        , manageHook    = manageDocks <+> myManageHook <+> manageHook defaultConfig
        , layoutHook    = avoidStruts  $  layoutHook defaultConfig
        , logHook       = myLogHook dzenLeftBar >> fadeInactiveLogHook 0xdddddddd
        , startupHook   = myStartup 
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        , ((0, xK_F6), lowerVolume 4 >> return())
        , ((0, xK_F7), raiseVolume 4 >> return())
        , ((mod4Mask, xK_q), spawn "killall conky dzen2 && xmonad --recompile && xmonad --restart")
        ]

myStartup :: X ()
myStartup = do
    spawn "conky -c conf/conky_main"

    --spawn "killall trayer; trayer --monitor 1 --transparent true --alpha 0 --tint 0x1B1D1E --edge bottom --expand true --SetPartialStrut true --SetDockType true --align left --height 24"

myWorkspaces = ["1:web","2:term","3:chat","4:vm","5:media","6:remote"]

myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP 
    { ppCurrent         = dzenColor "#ebac54" "#1B1D1E" . pad
    , ppVisible         = dzenColor "#FFFFFF" "#1B1D1E" . pad
    , ppHidden          = dzenColor "#FFFFFF" "#1B1D1E" . pad
    , ppHiddenNoWindows = dzenColor "#7b7b7b" "#1B1D1E" . pad
    , ppUrgent          = dzenColor "#ff0000" "#1B1D1E" . pad
    , ppLayout          = dzenColor "#ebac54" "#1B1D1E" . pad
    , ppTitle           = (" " ++) . dzenColor "#FFFFFF" "#1B1D1E" . dzenEscape
    , ppWsSep           = " "
    , ppSep             = " | "
    , ppOutput          = hPutStrLn h
    }

myManageHook = composeAll . concat $
    [ [ className =? "rdesktop"   --> doShift "6:remote"  ]
    , [ className =? "skype"      --> doShift "3:chat"    ]
    , [ className =? "Skype"      --> doShift "3:chat"    ]
    , [ className =? "urxvt"      --> doShift "2:term"    ]
    , [ className =? "firefox"    --> doShift "1:web"     ]
    , [ className =? "VirtualBox" --> doShift "4:vm"      ]
    , [ className =? "spotify-starter"    --> doShift "5:media"   ]
    ]
