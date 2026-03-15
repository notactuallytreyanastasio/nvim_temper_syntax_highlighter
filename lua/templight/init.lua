local temper = require('temper-core');
local isAlpha__274, isDigit__275, isAlphaNum__276, strLen__278, digitToChar__279, intToString__280, containsWord__281, isKeyword__282, isBuiltinType__283, isLiteral__284, emit__285, isOperatorChar__286, isTwoCharOp__287, isPunctuation__288, tokenizeLine, tokenizeMarkdownLine, exports;
isAlpha__274 = function(c__292)
  local return__257, t_0, t_1;
  if (c__292 >= 97) then
    t_0 = (c__292 <= 122);
  else
    t_0 = false;
  end
  if t_0 then
    return__257 = true;
  else
    if (c__292 >= 65) then
      t_1 = (c__292 <= 90);
    else
      t_1 = false;
    end
    if t_1 then
      return__257 = true;
    else
      return__257 = (c__292 == 95);
    end
  end
  return return__257;
end;
isDigit__275 = function(c__294)
  local return__258;
  if (c__294 >= 48) then
    return__258 = (c__294 <= 57);
  else
    return__258 = false;
  end
  return return__258;
end;
isAlphaNum__276 = function(c__296)
  local return__259;
  if isAlpha__274(c__296) then
    return__259 = true;
  else
    return__259 = isDigit__275(c__296);
  end
  return return__259;
end;
strLen__278 = function(s__300)
  local t_2, count__302, idx__303;
  count__302 = 0;
  idx__303 = 1.0;
  while true do
    if not temper.string_hasindex(s__300, idx__303) then
      break;
    end
    count__302 = temper.int32_add(count__302, 1);
    t_2 = temper.string_next(s__300, idx__303);
    idx__303 = t_2;
  end
  return count__302;
end;
digitToChar__279 = function(digit__304)
  local return__262;
  ::continue_1::
  if (digit__304 == 0) then
    return__262 = '0';
    goto break_0;
  end
  if (digit__304 == 1) then
    return__262 = '1';
    goto break_0;
  end
  if (digit__304 == 2) then
    return__262 = '2';
    goto break_0;
  end
  if (digit__304 == 3) then
    return__262 = '3';
    goto break_0;
  end
  if (digit__304 == 4) then
    return__262 = '4';
    goto break_0;
  end
  if (digit__304 == 5) then
    return__262 = '5';
    goto break_0;
  end
  if (digit__304 == 6) then
    return__262 = '6';
    goto break_0;
  end
  if (digit__304 == 7) then
    return__262 = '7';
    goto break_0;
  end
  if (digit__304 == 8) then
    return__262 = '8';
    goto break_0;
  end
  return__262 = '9';
  ::break_0::return return__262;
end;
intToString__280 = function(n__306)
  local return__263, t_3, t_4, result__308, remaining__309;
  ::continue_3::
  if (n__306 == 0) then
    return__263 = '0';
    goto break_2;
  end
  result__308 = '';
  remaining__309 = n__306;
  while (remaining__309 > 0) do
    local digit__310;
    t_3 = temper.int32_div(remaining__309, 10);
    digit__310 = temper.int32_sub(remaining__309, temper.int32_mul(t_3, 10));
    result__308 = temper.concat(digitToChar__279(digit__310), result__308);
    t_4 = temper.int32_div(remaining__309, 10);
    remaining__309 = t_4;
  end
  return__263 = result__308;
  ::break_2::return return__263;
end;
containsWord__281 = function(haystack__311, word__312)
  local return__264, t_5, t_6, t_7, t_8, t_9, t_10, t_11, padded__314, idx__315;
  ::continue_5::padded__314 = temper.concat('|', word__312, '|');
  idx__315 = 1.0;
  while true do
    local sj__316, pj__317, matched__318;
    if not temper.string_hasindex(haystack__311, idx__315) then
      break;
    end
    sj__316 = idx__315;
    pj__317 = 1.0;
    matched__318 = true;
    while true do
      if temper.string_hasindex(padded__314, pj__317) then
        t_5 = temper.string_hasindex(haystack__311, sj__316);
        t_10 = t_5;
      else
        t_10 = false;
      end
      if not t_10 then
        break;
      end
      if (temper.string_get(haystack__311, sj__316) ~= temper.string_get(padded__314, pj__317)) then
        matched__318 = false;
        break;
      end
      t_6 = temper.string_next(haystack__311, sj__316);
      sj__316 = t_6;
      t_7 = temper.string_next(padded__314, pj__317);
      pj__317 = t_7;
    end
    if matched__318 then
      t_8 = temper.string_hasindex(padded__314, pj__317);
      t_11 = not t_8;
    else
      t_11 = false;
    end
    if t_11 then
      return__264 = true;
      goto break_4;
    end
    t_9 = temper.string_next(haystack__311, idx__315);
    idx__315 = t_9;
  end
  return__264 = false;
  ::break_4::return return__264;
end;
isKeyword__282 = function(word__319)
  return containsWord__281('|let|class|interface|extends|when|is|new|return|if|else|for|while|fn|export|import|orelse|test|assert|do|of|throws|throw|try|catch|finally|break|continue|yield|async|await|public|private|sealed|static|const|var|match|enum|trait|impl|type|override|abstract|super|this|', word__319);
end;
isBuiltinType__283 = function(word__321)
  return containsWord__281('|Int|String|Float|Boolean|Void|Bubble|Listed|Mapped|StringIndex|List|Map|Set|Optional|Result|Error|Function|Promise|Iterator|', word__321);
end;
isLiteral__284 = function(word__323)
  local return__267;
  if temper.str_eq(word__323, 'true') then
    return__267 = true;
  elseif temper.str_eq(word__323, 'false') then
    return__267 = true;
  else
    return__267 = temper.str_eq(word__323, 'null');
  end
  return return__267;
end;
emit__285 = function(result__325, kind__326, length__327)
  local return__268;
  if temper.str_eq(result__325, '') then
    return__268 = temper.concat(kind__326, ':', intToString__280(length__327));
  else
    return__268 = temper.concat(result__325, ',', kind__326, ':', intToString__280(length__327));
  end
  return return__268;
end;
isOperatorChar__286 = function(c__329)
  local return__269;
  if (c__329 == 43) then
    return__269 = true;
  elseif (c__329 == 45) then
    return__269 = true;
  elseif (c__329 == 42) then
    return__269 = true;
  elseif (c__329 == 47) then
    return__269 = true;
  elseif (c__329 == 61) then
    return__269 = true;
  elseif (c__329 == 33) then
    return__269 = true;
  elseif (c__329 == 60) then
    return__269 = true;
  elseif (c__329 == 62) then
    return__269 = true;
  elseif (c__329 == 124) then
    return__269 = true;
  elseif (c__329 == 38) then
    return__269 = true;
  elseif (c__329 == 94) then
    return__269 = true;
  elseif (c__329 == 37) then
    return__269 = true;
  elseif (c__329 == 126) then
    return__269 = true;
  else
    return__269 = (c__329 == 63);
  end
  return return__269;
end;
isTwoCharOp__287 = function(code__331, idx__332)
  local return__270, t_12, t_13, t_14, t_15, t_16, t_17, t_18, t_19, t_20, t_21, next__334, a__335, b__336;
  ::continue_7::
  if not temper.string_hasindex(code__331, idx__332) then
    return__270 = false;
    goto break_6;
  end
  next__334 = temper.string_next(code__331, idx__332);
  if not temper.string_hasindex(code__331, next__334) then
    return__270 = false;
    goto break_6;
  end
  a__335 = temper.string_get(code__331, idx__332);
  b__336 = temper.string_get(code__331, next__334);
  if (a__335 == 61) then
    t_12 = (b__336 == 62);
  else
    t_12 = false;
  end
  if t_12 then
    return__270 = true;
  else
    if (a__335 == 45) then
      t_13 = (b__336 == 62);
    else
      t_13 = false;
    end
    if t_13 then
      return__270 = true;
    else
      if (a__335 == 61) then
        t_14 = (b__336 == 61);
      else
        t_14 = false;
      end
      if t_14 then
        return__270 = true;
      else
        if (a__335 == 33) then
          t_15 = (b__336 == 61);
        else
          t_15 = false;
        end
        if t_15 then
          return__270 = true;
        else
          if (a__335 == 60) then
            t_16 = (b__336 == 61);
          else
            t_16 = false;
          end
          if t_16 then
            return__270 = true;
          else
            if (a__335 == 62) then
              t_17 = (b__336 == 61);
            else
              t_17 = false;
            end
            if t_17 then
              return__270 = true;
            else
              if (a__335 == 38) then
                t_18 = (b__336 == 38);
              else
                t_18 = false;
              end
              if t_18 then
                return__270 = true;
              else
                if (a__335 == 124) then
                  t_19 = (b__336 == 124);
                else
                  t_19 = false;
                end
                if t_19 then
                  return__270 = true;
                else
                  if (a__335 == 63) then
                    t_20 = (b__336 == 63);
                  else
                    t_20 = false;
                  end
                  if t_20 then
                    return__270 = true;
                  else
                    if (a__335 == 63) then
                      t_21 = (b__336 == 46);
                    else
                      t_21 = false;
                    end
                    if t_21 then
                      return__270 = true;
                    elseif (a__335 == 46) then
                      return__270 = (b__336 == 46);
                    else
                      return__270 = false;
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  ::break_6::return return__270;
end;
isPunctuation__288 = function(c__337)
  local return__271;
  if (c__337 == 40) then
    return__271 = true;
  elseif (c__337 == 41) then
    return__271 = true;
  elseif (c__337 == 123) then
    return__271 = true;
  elseif (c__337 == 125) then
    return__271 = true;
  elseif (c__337 == 91) then
    return__271 = true;
  elseif (c__337 == 93) then
    return__271 = true;
  elseif (c__337 == 59) then
    return__271 = true;
  elseif (c__337 == 44) then
    return__271 = true;
  elseif (c__337 == 46) then
    return__271 = true;
  else
    return__271 = (c__337 == 58);
  end
  return return__271;
end;
tokenizeLine = function(line__339)
  local t_22, t_23, t_24, t_25, t_26, t_27, t_28, t_29, t_30, t_31, t_32, t_33, t_34, t_35, t_36, t_37, t_38, t_39, t_40, t_41, t_42, t_43, t_44, t_45, t_46, t_47, t_48, t_49, t_50, t_51, t_52, t_53, t_54, t_55, t_56, t_57, t_58, t_59, t_60, t_61, t_62, t_63, t_64, t_65, t_66, t_67, t_68, t_69, t_70, t_71, t_72, t_73, t_74, t_75, t_76, t_77, t_78, t_79, t_80, t_81, t_82, t_83, t_84, t_85, t_86, t_87, t_88, t_89, t_90, t_91, t_92, t_93, t_94, t_95, t_96, result__341, idx__342;
  result__341 = '';
  idx__342 = 1.0;
  while true do
    local c__343;
    if not temper.string_hasindex(line__339, idx__342) then
      break;
    end
    c__343 = temper.string_get(line__339, idx__342);
    if (c__343 == 47) then
      t_22 = temper.string_next(line__339, idx__342);
      if temper.string_hasindex(line__339, t_22) then
        t_23 = temper.string_next(line__339, idx__342);
        t_24 = temper.string_get(line__339, t_23);
        t_77 = (t_24 == 47);
      else
        t_77 = false;
      end
      t_78 = t_77;
    else
      t_78 = false;
    end
    if t_78 then
      local end__344, len__345;
      t_25 = temper.string_next(line__339, idx__342);
      t_26 = temper.string_next(line__339, t_25);
      end__344 = t_26;
      while true do
        if not temper.string_hasindex(line__339, end__344) then
          break;
        end
        t_27 = temper.string_next(line__339, end__344);
        end__344 = t_27;
      end
      t_28 = temper.string_slice(line__339, idx__342, end__344);
      len__345 = strLen__278(t_28);
      result__341 = emit__285(result__341, 'cm', len__345);
      idx__342 = end__344;
    else
      local end__349, escaped__350, done__351, len__353;
      if (c__343 == 47) then
        t_29 = temper.string_next(line__339, idx__342);
        if temper.string_hasindex(line__339, t_29) then
          t_30 = temper.string_next(line__339, idx__342);
          t_31 = temper.string_get(line__339, t_30);
          t_79 = (t_31 == 42);
        else
          t_79 = false;
        end
        t_80 = t_79;
      else
        t_80 = false;
      end
      if t_80 then
        local end__346, found__347, len__348;
        t_32 = temper.string_next(line__339, idx__342);
        t_33 = temper.string_next(line__339, t_32);
        end__346 = t_33;
        found__347 = false;
        while true do
          if temper.string_hasindex(line__339, end__346) then
            t_81 = not found__347;
          else
            t_81 = false;
          end
          if not t_81 then
            break;
          end
          if (temper.string_get(line__339, end__346) == 42) then
            t_34 = temper.string_next(line__339, end__346);
            if temper.string_hasindex(line__339, t_34) then
              t_35 = temper.string_next(line__339, end__346);
              t_36 = temper.string_get(line__339, t_35);
              t_82 = (t_36 == 47);
            else
              t_82 = false;
            end
            t_83 = t_82;
          else
            t_83 = false;
          end
          if t_83 then
            t_37 = temper.string_next(line__339, end__346);
            t_38 = temper.string_next(line__339, t_37);
            end__346 = t_38;
            found__347 = true;
          else
            t_39 = temper.string_next(line__339, end__346);
            end__346 = t_39;
          end
        end
        t_40 = temper.string_slice(line__339, idx__342, end__346);
        len__348 = strLen__278(t_40);
        result__341 = emit__285(result__341, 'cm', len__348);
        idx__342 = end__346;
      elseif (c__343 == 34) then
        t_41 = temper.string_next(line__339, idx__342);
        end__349 = t_41;
        escaped__350 = false;
        done__351 = false;
        while true do
          local sc__352;
          if temper.string_hasindex(line__339, end__349) then
            t_84 = not done__351;
          else
            t_84 = false;
          end
          if not t_84 then
            break;
          end
          sc__352 = temper.string_get(line__339, end__349);
          if escaped__350 then
            escaped__350 = false;
            t_42 = temper.string_next(line__339, end__349);
            end__349 = t_42;
          elseif (sc__352 == 92) then
            escaped__350 = true;
            t_43 = temper.string_next(line__339, end__349);
            end__349 = t_43;
          elseif (sc__352 == 34) then
            t_44 = temper.string_next(line__339, end__349);
            end__349 = t_44;
            done__351 = true;
          else
            t_45 = temper.string_next(line__339, end__349);
            end__349 = t_45;
          end
        end
        t_46 = temper.string_slice(line__339, idx__342, end__349);
        len__353 = strLen__278(t_46);
        result__341 = emit__285(result__341, 'st', len__353);
        idx__342 = end__349;
      else
        local end__356, word__357, end__360, len__361;
        if (c__343 == 64) then
          t_47 = temper.string_next(line__339, idx__342);
          if temper.string_hasindex(line__339, t_47) then
            t_48 = temper.string_next(line__339, idx__342);
            t_49 = temper.string_get(line__339, t_48);
            t_85 = isAlpha__274(t_49);
          else
            t_85 = false;
          end
          t_86 = t_85;
        else
          t_86 = false;
        end
        if t_86 then
          local end__354, len__355;
          t_50 = temper.string_next(line__339, idx__342);
          end__354 = t_50;
          while true do
            if temper.string_hasindex(line__339, end__354) then
              t_51 = temper.string_get(line__339, end__354);
              t_87 = isAlphaNum__276(t_51);
            else
              t_87 = false;
            end
            if not t_87 then
              break;
            end
            t_52 = temper.string_next(line__339, end__354);
            end__354 = t_52;
          end
          t_53 = temper.string_slice(line__339, idx__342, end__354);
          len__355 = strLen__278(t_53);
          result__341 = emit__285(result__341, 'dc', len__355);
          idx__342 = end__354;
        elseif isAlpha__274(c__343) then
          end__356 = idx__342;
          while true do
            if temper.string_hasindex(line__339, end__356) then
              t_54 = temper.string_get(line__339, end__356);
              t_88 = isAlphaNum__276(t_54);
            else
              t_88 = false;
            end
            if not t_88 then
              break;
            end
            t_55 = temper.string_next(line__339, end__356);
            end__356 = t_55;
          end
          word__357 = temper.string_slice(line__339, idx__342, end__356);
          if temper.str_eq(word__357, 'char') then
            if temper.string_hasindex(line__339, end__356) then
              t_56 = temper.string_get(line__339, end__356);
              t_89 = (t_56 == 39);
            else
              t_89 = false;
            end
            t_90 = t_89;
          else
            t_90 = false;
          end
          if t_90 then
            local charEnd__358, len__359;
            t_57 = temper.string_next(line__339, end__356);
            charEnd__358 = t_57;
            while true do
              if temper.string_hasindex(line__339, charEnd__358) then
                t_58 = temper.string_get(line__339, charEnd__358);
                t_91 = (t_58 ~= 39);
              else
                t_91 = false;
              end
              if not t_91 then
                break;
              end
              t_59 = temper.string_next(line__339, charEnd__358);
              charEnd__358 = t_59;
            end
            if temper.string_hasindex(line__339, charEnd__358) then
              t_60 = temper.string_next(line__339, charEnd__358);
              charEnd__358 = t_60;
            end
            t_61 = temper.string_slice(line__339, idx__342, charEnd__358);
            len__359 = strLen__278(t_61);
            result__341 = emit__285(result__341, 'ch', len__359);
            idx__342 = charEnd__358;
          elseif isLiteral__284(word__357) then
            t_62 = strLen__278(word__357);
            result__341 = emit__285(result__341, 'lt', t_62);
            idx__342 = end__356;
          elseif isKeyword__282(word__357) then
            t_63 = strLen__278(word__357);
            result__341 = emit__285(result__341, 'kw', t_63);
            idx__342 = end__356;
          elseif isBuiltinType__283(word__357) then
            t_64 = strLen__278(word__357);
            result__341 = emit__285(result__341, 'ty', t_64);
            idx__342 = end__356;
          else
            t_65 = strLen__278(word__357);
            result__341 = emit__285(result__341, 'id', t_65);
            idx__342 = end__356;
          end
        elseif isDigit__275(c__343) then
          end__360 = idx__342;
          while true do
            if temper.string_hasindex(line__339, end__360) then
              if isDigit__275(temper.string_get(line__339, end__360)) then
                t_92 = true;
              else
                t_66 = temper.string_get(line__339, end__360);
                t_92 = (t_66 == 46);
              end
              t_93 = t_92;
            else
              t_93 = false;
            end
            if not t_93 then
              break;
            end
            t_67 = temper.string_next(line__339, end__360);
            end__360 = t_67;
          end
          t_68 = temper.string_slice(line__339, idx__342, end__360);
          len__361 = strLen__278(t_68);
          result__341 = emit__285(result__341, 'nm', len__361);
          idx__342 = end__360;
        elseif isTwoCharOp__287(line__339, idx__342) then
          result__341 = emit__285(result__341, 'op', 2);
          t_69 = temper.string_next(line__339, idx__342);
          t_70 = temper.string_next(line__339, t_69);
          idx__342 = t_70;
        elseif isOperatorChar__286(c__343) then
          result__341 = emit__285(result__341, 'op', 1);
          t_71 = temper.string_next(line__339, idx__342);
          idx__342 = t_71;
        else
          if (c__343 == 32) then
            t_94 = true;
          else
            t_94 = (c__343 == 9);
          end
          if t_94 then
            local end__362, len__363;
            end__362 = idx__342;
            while true do
              if temper.string_hasindex(line__339, end__362) then
                if (temper.string_get(line__339, end__362) == 32) then
                  t_95 = true;
                else
                  t_72 = temper.string_get(line__339, end__362);
                  t_95 = (t_72 == 9);
                end
                t_96 = t_95;
              else
                t_96 = false;
              end
              if not t_96 then
                break;
              end
              t_73 = temper.string_next(line__339, end__362);
              end__362 = t_73;
            end
            t_74 = temper.string_slice(line__339, idx__342, end__362);
            len__363 = strLen__278(t_74);
            result__341 = emit__285(result__341, 'ws', len__363);
            idx__342 = end__362;
          elseif isPunctuation__288(c__343) then
            result__341 = emit__285(result__341, 'pn', 1);
            t_75 = temper.string_next(line__339, idx__342);
            idx__342 = t_75;
          else
            result__341 = emit__285(result__341, 'id', 1);
            t_76 = temper.string_next(line__339, idx__342);
            idx__342 = t_76;
          end
        end
      end
    end
  end
  return result__341;
end;
tokenizeMarkdownLine = function(line__364)
  local return__273, t_97, t_98, t_99, t_100, t_101, t_102, t_103, t_104, t_105, t_106, t_107, t_108, t_109, t_110, t_111, t_112, t_113, t_114, t_115, t_116, t_117, t_118, t_119, t_120, t_121, t_122, t_123, t_124, t_125, t_126, t_127, t_128, t_129, t_130, t_131, t_132, t_133, t_134, t_135, t_136, t_137, t_138, t_139, t_140, t_141, t_142, t_143, result__366, idx__367, len__368;
  ::continue_9::result__366 = '';
  idx__367 = 1.0;
  len__368 = strLen__278(line__364);
  if (len__368 == 0) then
    return__273 = result__366;
    goto break_8;
  end
  if (temper.string_get(line__364, idx__367) == 35) then
    result__366 = emit__285(result__366, 'mh', len__368);
    return__273 = result__366;
    goto break_8;
  end
  if (len__368 >= 3) then
    local c0__369, i1__370, c1__371, i2__372, c2__373;
    c0__369 = temper.string_get(line__364, idx__367);
    i1__370 = temper.string_next(line__364, idx__367);
    c1__371 = temper.string_get(line__364, i1__370);
    i2__372 = temper.string_next(line__364, i1__370);
    c2__373 = temper.string_get(line__364, i2__372);
    if (c0__369 == 96) then
      if (c1__371 == 96) then
        t_128 = (c2__373 == 96);
      else
        t_128 = false;
      end
      t_129 = t_128;
    else
      t_129 = false;
    end
    if t_129 then
      result__366 = emit__285(result__366, 'mf', len__368);
      return__273 = result__366;
      goto break_8;
    end
  end
  while true do
    local c__374;
    if not temper.string_hasindex(line__364, idx__367) then
      break;
    end
    c__374 = temper.string_get(line__364, idx__367);
    if (c__374 == 96) then
      local end__375, found__376, tokenLen__377;
      t_97 = temper.string_next(line__364, idx__367);
      end__375 = t_97;
      found__376 = false;
      while true do
        if temper.string_hasindex(line__364, end__375) then
          t_130 = not found__376;
        else
          t_130 = false;
        end
        if not t_130 then
          break;
        end
        if (temper.string_get(line__364, end__375) == 96) then
          t_98 = temper.string_next(line__364, end__375);
          end__375 = t_98;
          found__376 = true;
        else
          t_99 = temper.string_next(line__364, end__375);
          end__375 = t_99;
        end
      end
      t_100 = temper.string_slice(line__364, idx__367, end__375);
      tokenLen__377 = strLen__278(t_100);
      result__366 = emit__285(result__366, 'mc', tokenLen__377);
      idx__367 = end__375;
    else
      if (c__374 == 42) then
        t_101 = temper.string_next(line__364, idx__367);
        if temper.string_hasindex(line__364, t_101) then
          t_102 = temper.string_next(line__364, idx__367);
          t_103 = temper.string_get(line__364, t_102);
          t_131 = (t_103 == 42);
        else
          t_131 = false;
        end
        t_132 = t_131;
      else
        t_132 = false;
      end
      if t_132 then
        local end__378, found__379, tokenLen__380;
        t_104 = temper.string_next(line__364, idx__367);
        t_105 = temper.string_next(line__364, t_104);
        end__378 = t_105;
        found__379 = false;
        while true do
          if temper.string_hasindex(line__364, end__378) then
            t_133 = not found__379;
          else
            t_133 = false;
          end
          if not t_133 then
            break;
          end
          if (temper.string_get(line__364, end__378) == 42) then
            t_106 = temper.string_next(line__364, end__378);
            if temper.string_hasindex(line__364, t_106) then
              t_107 = temper.string_next(line__364, end__378);
              t_108 = temper.string_get(line__364, t_107);
              t_134 = (t_108 == 42);
            else
              t_134 = false;
            end
            t_135 = t_134;
          else
            t_135 = false;
          end
          if t_135 then
            t_109 = temper.string_next(line__364, end__378);
            t_110 = temper.string_next(line__364, t_109);
            end__378 = t_110;
            found__379 = true;
          else
            t_111 = temper.string_next(line__364, end__378);
            end__378 = t_111;
          end
        end
        t_112 = temper.string_slice(line__364, idx__367, end__378);
        tokenLen__380 = strLen__278(t_112);
        result__366 = emit__285(result__366, 'mb', tokenLen__380);
        idx__367 = end__378;
      else
        local end__385, found__386, tokenLen__387;
        if (c__374 == 42) then
          t_136 = true;
        else
          t_136 = (c__374 == 95);
        end
        if t_136 then
          local marker__381, end__382, found__383, tokenLen__384;
          marker__381 = c__374;
          t_113 = temper.string_next(line__364, idx__367);
          end__382 = t_113;
          found__383 = false;
          while true do
            if temper.string_hasindex(line__364, end__382) then
              t_137 = not found__383;
            else
              t_137 = false;
            end
            if not t_137 then
              break;
            end
            if (temper.string_get(line__364, end__382) == marker__381) then
              t_114 = temper.string_next(line__364, end__382);
              end__382 = t_114;
              found__383 = true;
            else
              t_115 = temper.string_next(line__364, end__382);
              end__382 = t_115;
            end
          end
          t_116 = temper.string_slice(line__364, idx__367, end__382);
          tokenLen__384 = strLen__278(t_116);
          result__366 = emit__285(result__366, 'me', tokenLen__384);
          idx__367 = end__382;
        elseif (c__374 == 91) then
          t_117 = temper.string_next(line__364, idx__367);
          end__385 = t_117;
          found__386 = false;
          while true do
            if temper.string_hasindex(line__364, end__385) then
              t_138 = not found__386;
            else
              t_138 = false;
            end
            if not t_138 then
              break;
            end
            if (temper.string_get(line__364, end__385) == 93) then
              t_118 = temper.string_next(line__364, end__385);
              end__385 = t_118;
              if temper.string_hasindex(line__364, end__385) then
                t_119 = temper.string_get(line__364, end__385);
                t_139 = (t_119 == 40);
              else
                t_139 = false;
              end
              if t_139 then
                while true do
                  if temper.string_hasindex(line__364, end__385) then
                    t_120 = temper.string_get(line__364, end__385);
                    t_140 = (t_120 ~= 41);
                  else
                    t_140 = false;
                  end
                  if not t_140 then
                    break;
                  end
                  t_121 = temper.string_next(line__364, end__385);
                  end__385 = t_121;
                end
                if temper.string_hasindex(line__364, end__385) then
                  t_122 = temper.string_next(line__364, end__385);
                  end__385 = t_122;
                end
              end
              found__386 = true;
            else
              t_123 = temper.string_next(line__364, end__385);
              end__385 = t_123;
            end
          end
          t_124 = temper.string_slice(line__364, idx__367, end__385);
          tokenLen__387 = strLen__278(t_124);
          result__366 = emit__285(result__366, 'ml', tokenLen__387);
          idx__367 = end__385;
        else
          local end__388, tokenLen__390;
          t_125 = temper.string_next(line__364, idx__367);
          end__388 = t_125;
          while true do
            local nc__389;
            if not temper.string_hasindex(line__364, end__388) then
              break;
            end
            nc__389 = temper.string_get(line__364, end__388);
            if (nc__389 == 96) then
              t_143 = true;
            else
              if (nc__389 == 42) then
                t_142 = true;
              else
                if (nc__389 == 95) then
                  t_141 = true;
                else
                  t_141 = (nc__389 == 91);
                end
                t_142 = t_141;
              end
              t_143 = t_142;
            end
            if t_143 then
              break;
            end
            t_126 = temper.string_next(line__364, end__388);
            end__388 = t_126;
          end
          t_127 = temper.string_slice(line__364, idx__367, end__388);
          tokenLen__390 = strLen__278(t_127);
          result__366 = emit__285(result__366, 'mt', tokenLen__390);
          idx__367 = end__388;
        end
      end
    end
  end
  return__273 = result__366;
  ::break_8::return return__273;
end;
exports = {};
exports.tokenizeLine = tokenizeLine;
exports.tokenizeMarkdownLine = tokenizeMarkdownLine;
return exports;
