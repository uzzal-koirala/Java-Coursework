package service;

import dao.ReplyDAO;
import model.Reply;
import java.util.List;

public class ReplyService {
    private ReplyDAO replyDAO = new ReplyDAO();

    public boolean addReply(Reply reply) {
        return replyDAO.addReply(reply);
    }

    public List<Reply> getReplies(int gunasoId) {
        return replyDAO.getRepliesByGunasoId(gunasoId);
    }
}
