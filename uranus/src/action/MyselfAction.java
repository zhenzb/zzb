package action;

import java.security.spec.AlgorithmParameterSpec;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.annotation.WebServlet;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import action.service.MyselfService;
import action.service.UserService;
import action.service.WalletService;
import action.service.WechatPayService;
import cache.BaseCache;
import common.PropertiesConf;
import servlet.BaseServlet;
import org.apache.tomcat.util.codec.binary.Base64;
import utils.WXCore;


@WebServlet(name = "Myself", urlPatterns = "/myself")
public class MyselfAction extends BaseServlet {

    private static final long serialVersionUID = 1L;

    public static String inviteFriends(String token) {
        String useId = UserService.getUserIdByToken(token);
        if (useId == null) {
            return creatResult(2, "亲，未登录....", null).toString();
        }

        //查询用户信息，用户手机号就是邀请码
        JSONArray inviteCode = MyselfService.inviteCode(useId);
        //查询邀请列表信息
        JSONArray inviteResult = MyselfService.inviteFriends(useId);


        HashMap<String, Object> resMap = new HashMap<String, Object>();
        resMap.put("OrderList", inviteResult);
        resMap.put("inviteCode", inviteCode);
        return creatResult(1, "亲，数据包回来了", resMap).toString();
    }

    /**
     * 我的钱包
     */
    public static String Mywallet(String token, String nowMonth) {
        String useId = UserService.getUserIdByToken(token);
        if (useId == null) {
            return creatResult(2, "亲，未登录....", null).toString();
        }

        //查询用户信息，用户手机号就是邀请码
        String balanceStr = WalletService.getBalance(useId);
        JSONObject balanceJson = JSONObject.parseObject(balanceStr);
        JSONArray balance = balanceJson.getJSONObject("result").getJSONArray("rs");
        //查询钱包列表信息
        JSONArray wallet = MyselfService.findWalletList(useId, nowMonth);

        HashMap<String, Object> resMap = new HashMap<String, Object>();
        resMap.put("balance", balance);
        resMap.put("wallet", wallet);
        return creatResult(1, "亲，数据包回来了", resMap).toString();
    }

    /**
     * 我的模块下礼包属性商品列表	sku_id层级的列表
     */
    public static String findGiftGoodList(String begin, String end) {
        //mysql limit的起始索引为0,便于前台理解，所以用此方式
        Integer beginNum = Integer.valueOf(begin) - 1;
        Integer endNum = Integer.valueOf(end);

        String searchGiftGoodsStr = MyselfService.findGiftGoodList(beginNum, endNum);
        JSONObject searchGiftGoods = JSONObject.parseObject(searchGiftGoodsStr);
        HashMap<String, Object> resMap = new HashMap<String, Object>();
        resMap.put("searchGiftGoods", searchGiftGoods);
        return creatResult(1, "亲,数据包回来了哦...", resMap).toString();
    }

    /**
     * 我的邀请好友 确定下级接口
     */
    public static String confirmSupmember(String token, String phone) {
        String useId = UserService.getUserIdByToken(token);
        if (useId == null) {
            return creatResult(2, "亲，未登录....", null).toString();
        }

        Integer hasId = UserService.hasUserByPhone(phone);
        if (hasId == null) {
            return creatResult(3, "邀请用户不存在", null).toString();
        }
        //判断该用户是否已经有了上级
        String userMsgStr = MyselfService.getUserMsg(useId);
        JSONObject userMsg = JSONObject.parseObject(userMsgStr);
        //用户表分类不为空的情况
        String parentUser = userMsg.getJSONObject("result").getJSONArray("rs").getJSONObject(0).getString("parent_user_id");
        Integer parentUserId = parentUser.endsWith("") ? 0 : Integer.valueOf(parentUser);
        //切记测试邀请人的时候,手动改parentUserId,导致邀请人重复,前后台对不上
        if (parentUserId != 0) {
            return creatResult(5, "该用户已经绑定了邀请人", null).toString();
        }

        //(先判断你是否是我的下级,而我刚好没有上级的情况)
        String findIsNotSonStr = MyselfService.findIsNotSon(useId);
        JSONArray findIsNotSon = JSONObject.parseObject(findIsNotSonStr).getJSONObject("result").getJSONArray("rs");
        for (int i = 0; i < findIsNotSon.size(); i++) {
            if (findIsNotSon.getJSONObject(i).getString("phone").equals(phone)) {
                return creatResult(4, "邀请人是你自己或下级哦", null).toString();
            }
        }

        String confirmSupmemberStr = MyselfService.confirmSupmember(useId, phone);
        JSONObject result = JSONObject.parseObject(confirmSupmemberStr);
        HashMap<String, Object> resMap = new HashMap<String, Object>();
        resMap.put("result", result);
        return creatResult(1, "亲,数据包回来了哦...", resMap).toString();
    }

    /**
     * 查询我的上级接口
     */
    public static String findSupmember(String token) {
        String useId = UserService.getUserIdByToken(token);
        if (useId == null) {
            return creatResult(2, "亲，未登录....", null).toString();
        }
        String findSupmemberStr = MyselfService.findSupmember(useId);
        JSONObject result = JSONObject.parseObject(findSupmemberStr);
        JSONArray resultJson = result.getJSONObject("result").getJSONArray("rs");
        if (resultJson.size() == 0) {
            return creatResult(3, "亲,该用户无上级...", null).toString();
        }
        String nickName = resultJson.getJSONObject(0).getString("nick_name");
        String phone = resultJson.getJSONObject(0).getString("phone");
        HashMap<String, Object> resMap = new HashMap<String, Object>();
        resMap.put("nickName", nickName);
        resMap.put("phone", phone);
        return creatResult(1, "亲,数据包回来了哦...", resMap).toString();
    }

    /**
     * 查询我的列表(用户是会员状态下)
     */
    public static String findMember(String token) {
        String useId = UserService.getUserIdByToken(token);
        if (useId == null) {
            return creatResult(2, "亲，未登录....", null).toString();
        }
        //生成当前时间
        String nowTime = BaseCache.getTIME();
        String findMemberStr = MyselfService.findMember(useId, nowTime);
        JSONObject result = JSONObject.parseObject(findMemberStr);
        HashMap<String, Object> resMap = new HashMap<String, Object>();
        resMap.put("result", result);
        return creatResult(1, "亲,数据包回来了哦...", resMap).toString();
    }

    /**
     * 收藏列表（商品详情页商品收藏功能）
     */
    public static String storeGoods(String token, String spuId) {
        String useId = UserService.getUserIdByToken(token);
        if (useId == null) {
            return creatResult(2, "亲，未登录....", null).toString();
        }
        //生成当前时间
        String nowTime = BaseCache.getTIME();
        String storeGoodsStr = MyselfService.storeGoods(useId, nowTime, spuId);
        JSONObject result = JSONObject.parseObject(storeGoodsStr);
        HashMap<String, Object> resMap = new HashMap<String, Object>();
        resMap.put("result", result);
        return creatResult(1, "亲,数据包回来了哦...", resMap).toString();
    }

    /**
     * 批量取消收藏
     */
    public static String unStoreGoodsList(String token, String spuIdStr) {
        String useId = UserService.getUserIdByToken(token);
        if (useId == null) {
            return creatResult(2, "亲，未登录....", null).toString();
        }
        String unStoreGoodsListInt = MyselfService.unStoreGoodsList(useId, spuIdStr);
        JSONObject result = JSONObject.parseObject(unStoreGoodsListInt);
        HashMap<String, Object> resMap = new HashMap<String, Object>();
        resMap.put("result", result);
        return creatResult(1, "亲,数据包回来了哦...", resMap).toString();
    }

    /**
     * 我的收藏列表
     */
    public static String findStoreGoodsList(String token, String begin, String end) {
        String useId = UserService.getUserIdByToken(token);
        if (useId == null) {
            return creatResult(2, "亲，未登录....", null).toString();
        }

        //mysql limit的起始索引为0,便于前台理解，所以用此方式
        Integer beginNum = Integer.valueOf(begin) - 1;
        Integer endNum = Integer.valueOf(end);

        String storeGoodsListInt = MyselfService.findStoreGoodsList(useId, beginNum, endNum);
        JSONObject result = JSONObject.parseObject(storeGoodsListInt);
        HashMap<String, Object> resMap = new HashMap<String, Object>();
        resMap.put("result", result);
        return creatResult(1, "亲,数据包回来了哦...", resMap).toString();
    }


    /**
     * 解密手机号
     */
    public static String getSignPhone(String encryptedData, String iv, String js_code) throws Exception {
        String sessionId = "";
        if(iv.equals("undefined")){
            return "";
        }
        Map<String, Object> resultMap = WechatPayService.findOpenid(js_code);
        if (resultMap != null) {
            sessionId = resultMap.get("session_key").toString();
        }
        String json = WXCore.decrypt(PropertiesConf.APP_ID, encryptedData, sessionId, iv);
        if (json == "") {
            return "";
        }
        JSONObject parse = (JSONObject) JSONObject.parse(json);
        //appid为机密文件必选在文件中予以排除
        return (String) parse.get("phoneNumber");
    }

    /**
     * 废弃
     *
     * @param key
     * @param iv
     * @param encData
     * @return
     * @throws Exception
     */
    public static String decrypt(byte[] key, byte[] iv, byte[] encData) throws Exception {
        AlgorithmParameterSpec ivSpec = new IvParameterSpec(iv);
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecretKeySpec keySpec = new SecretKeySpec(key, "AES");
        cipher.init(Cipher.DECRYPT_MODE, keySpec, ivSpec);
        //解析解密后的字符串
        return new String(cipher.doFinal(encData), "UTF-8");
    }

} 