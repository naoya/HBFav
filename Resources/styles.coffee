HBFav.UI.styles =
  timeline:
    profileImage:
      # opacity: 1.0
      backgroundColor: "#fff"
      width: 48
      height: 48
      # width: 32
      # height: 32
      top: 10
      left: 10
      # borderRadius: 5

    profileImageContainer:
      backgroundColor: "#fff"
      width: 'auto'
      height: 68
      # height: '52'
      top: 0
      left: 0

    bodyContainer:
      layout: 'vertical'
      width: 245
      height: 'auto'
      left: 65
      # left: 50
      top: 0

    nameLabel:
      width: 'auto'
      height: 'auto'
      left: 0
      top: 10
      bottom: 5
      color: '#000'
      backgroundColor: "#fff"
      font:
        fontSize : 16
        fontWeight: 'bold'

    commentLabel:
      backgroundColor: "#fff"
      opaque: true
      color: '#000'
      top: 0
      left: 0
      width: 'auto'
      height: 'auto'
      bottom: 10
      font:
        fontSize: 16

    titleContainer:
      layout: 'horizontal'
      width: 245
      height: 'auto'
      top: 0
      left: 0
      bottom: 10

    titleLabel:
      backgroundColor: "#fff"
      opacity: 1.0
      opaque: true
      color: '#3B5998'
      top: 0
      left: 3
      width: 'auto'
      height: 'auto'
      font:
        fontSize: 16

    favicon:
      backgroundColor: "#fff"
      opacity: 1.0
      width: 16
      height: 16
      top: 2
      left: 0

    dateLabel:
      width: 'auto'
      height: 'auto'
      top: 10
      right: 10
      color: '#999'
      backgroundColor: "#fff"
      opacity: 1.0
      font:
        fontSize: 14

  form:
    label:
      width: 'auto'
      height: 'auto'
      color: "#333"
      shadowColor: "#fff"
      shadowOffset:
        x: 0
        y: 1
      font:
        fontSize: 14
        fontWeight: "bold"

    textInput:
      color: '#194C7F'
      top: 6
      left: 10
      width: 300
      height: 40
      backgroundColor: "#fff"
      borderRadius: 10
      font:
        fontSize: 16
      paddingLeft: 10
      paddingRight: 10

    notice:
      width: 'auto'
      height: 'auto'
      left: 30
      right: 30
      textAlign: "center"
      color: "#333"
      shadowColor: "#fff"
      shadowOffset:
        x: 0
        y: 1
      font:
        fontSize: 12
        fontWeight: "bold"

$$ = HBFav.UI.styles